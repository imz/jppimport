#!/usr/bin/perl -w

#require 'add_missingok_config.pl';

push @SPECHOOKS, 
sub {
    my ($spec, $parent) = @_;
};
__END__
    # Следующие пакеты имеют неудовлетворенные зависимости:
    # maven2: Требует: /etc/mavenrc но пакет не может быть установлен
    #&add_missingok_config($spec,'/etc/mavenrc');

    #$spec->get_section('package')->set_tag(q!Epoch:!,1);

    $spec->get_section('package','-n maven-model')->push_body(q!# it was a tmp package during migration
Obsoletes:       maven-model22 < 0:%{version}-%{release}!."\n");

    $spec->main_section->push_body(q!
Obsoletes:       maven2-plugin-jxr <= 0:2.0.4 
Obsoletes:       maven2-plugin-surefire <= 0:2.0.4 
Obsoletes:       maven2-plugin-surefire-report <= 0:2.0.4 
Obsoletes:       maven2-plugin-release <= 0:2.0.4 
!."\n");
    $srcid=$spec->add_source('maven3-jpp-script');
    $spec->get_section('install')->push_body(q!
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

