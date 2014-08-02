#!/usr/bin/perl -w

#require 'add_missingok_config.pl';

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;

    # Следующие пакеты имеют неудовлетворенные зависимости:
    # maven2: Требует: /etc/mavenrc но пакет не может быть установлен
    #&add_missingok_config($jpp,'/etc/mavenrc');

    #$jpp->get_section('package')->set_tag(q!Epoch:!,1);

    $jpp->get_section('package','-n maven-model')->push_body(q!# it was a tmp package during migration
Obsoletes:       maven-model22 < 0:%{version}-%{release}!."\n");

    $jpp->main_section->push_body(q!
Obsoletes:       maven2-plugin-jxr <= 0:2.0.4 
Obsoletes:       maven2-plugin-surefire <= 0:2.0.4 
Obsoletes:       maven2-plugin-surefire-report <= 0:2.0.4 
Obsoletes:       maven2-plugin-release <= 0:2.0.4 
!."\n");
    $srcid=$jpp->add_source('maven3-jpp-script');
    $jpp->get_section('install')->push_body(q!
%post
# clear the old links
[ -d %{_datadir}/%{name}/boot/ ] && find %{_datadir}/%{name}/boot/ -type l -exec rm -f '{}' \; ||:
[ -d %{_datadir}/%{name}/lib/ ] && find %{_datadir}/%{name}/lib/ -type l -exec rm -f '{}' \; ||:

%postun
# FIXME: This doesn't always remove the plugins dir. It seems that rpm doesn't
# honour the Requires(postun) as it should, causing maven to get uninstalled 
# before some plugins are
if [ -d %{_javadir}/%{name} ] ; then rmdir --ignore-fail-on-non-empty %{_javadir}/%{name} >& /dev/null; fi
!."\n");

};

__END__

# Items in %%{_bindir}
install -Dm 755 %{SOURCE!.$srcid.q!} $RPM_BUILD_ROOT%{_bindir}/mvn-jpp

    $jpp->add_section('files')->push_body(q!%attr(0755,root,root) %{_bindir}/mvn-jpp!."\n");

