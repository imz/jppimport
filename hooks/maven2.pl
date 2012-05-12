#!/usr/bin/perl -w

#require 'add_missingok_config.pl';

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;

    # Следующие пакеты имеют неудовлетворенные зависимости:
    # maven2: Требует: /etc/mavenrc но пакет не может быть установлен
    #&add_missingok_config($jpp,'/etc/mavenrc');

    $jpp->rename_package('-n maven-model','-n maven-model22');
    $jpp->main_section->subst_body_if(qr'maven-model','maven-model22',qr'Requires');
    $jpp->get_section('files','-n maven-model22')->subst_body_if(qr'maven-model','maven-model22',qr'mavendepmapfragdir');
    $jpp->get_section('install')->push_body(q!# maven-model22
mv $RPM_BUILD_ROOT%{_mavendepmapfragdir}/maven-model \
   $RPM_BUILD_ROOT%{_mavendepmapfragdir}/maven-model22
!);

    $srcid=$jpp->add_source('maven3-jpp-script');
    $jpp->main_section->push_body(q!
Provides:        maven2-bootstrap = %{epoch}:%{version}-%{release}
Obsoletes:       maven2-plugin-jxr <= 0:2.0.4 
Obsoletes:       maven2-plugin-surefire <= 0:2.0.4 
Obsoletes:       maven2-plugin-surefire-report <= 0:2.0.4 
Obsoletes:       maven2-plugin-release <= 0:2.0.4 
!."\n");
    $jpp->get_section('install')->push_body(q!
# Items in %%{_bindir}
install -Dm 755 %{SOURCE!.$srcid.q!} $RPM_BUILD_ROOT%{_bindir}/mvn-jpp

%post
# clear the old links
find %{_datadir}/%{name}/boot/ -type l -exec rm -f '{}' \; ||:
find %{_datadir}/%{name}/lib/ -type l -exec rm -f '{}' \; ||:

%postun
# FIXME: This doesn't always remove the plugins dir. It seems that rpm doesn't
# honour the Requires(postun) as it should, causing maven to get uninstalled 
# before some plugins are
if [ -d %{_javadir}/%{name} ] ; then rmdir --ignore-fail-on-non-empty %{_javadir}/%{name} >& /dev/null; fi
!."\n");

    $jpp->get_section('files')->push_body(q!%attr(0755,root,root) %{_bindir}/mvn-jpp!."\n");

};

__END__
