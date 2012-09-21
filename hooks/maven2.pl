#!/usr/bin/perl -w

#require 'add_missingok_config.pl';

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;

    # Следующие пакеты имеют неудовлетворенные зависимости:
    # maven2: Требует: /etc/mavenrc но пакет не может быть установлен
    #&add_missingok_config($jpp,'/etc/mavenrc');

    $jpp->get_section('package','-n maven-model')->push_body(q!Epoch: 1
Obsoletes:       maven-model22 < 0:%{version}-%{release}!."\n");

    $jpp->copy_to_sources('%{name}-empty-dep.pom');
    $jpp->copy_to_sources('%{name}-empty-dep.jar');
    $jpp->get_section('package','')->unshift_body_after(qr'^Source103','Source104:    %{name}-empty-dep.pom
Source105:    %{name}-empty-dep.jar'."\n");

    $jpp->get_section('package','')->unshift_body_before(qr'^BuildArch','
Requires: maven-artifact-manager = %{?epoch:%epoch:}%{version}-%{release}
Requires: maven-error-diagnostics = %{?epoch:%epoch:}%{version}-%{release}
Requires: maven-model = 1:%{version}-%{release}
Requires: maven-monitor = %{?epoch:%epoch:}%{version}-%{release}
Requires: maven-plugin-registry = %{?epoch:%epoch:}%{version}-%{release}
Requires: maven-profile = %{?epoch:%epoch:}%{version}-%{release}
Requires: maven-project = %{?epoch:%epoch:}%{version}-%{release}
Requires: maven-toolchain = %{?epoch:%epoch:}%{version}-%{release}
Requires: maven-plugin-descriptor = %{?epoch:%epoch:}%{version}-%{release}
');


    $jpp->get_section('install')->unshift_body_after(qr'^install','
install -dm 755 $RPM_BUILD_ROOT%{_javadir}/%{name}

###########
# M2_HOME #
###########
install -dm 755 $RPM_BUILD_ROOT%{_datadir}/%{name}

################
# M2_HOME/poms #
#*##############
install -dm 755 $RPM_BUILD_ROOT%{_datadir}/%{name}/poms

############
# /usr/bin #
############
install -dm 755 $RPM_BUILD_ROOT%{_bindir}

# Install files
install -m 644 %{SOURCE104} $RPM_BUILD_ROOT%{_datadir}/%{name}/poms/JPP.maven2-empty-dep.pom
install -m 644 %{SOURCE105} $RPM_BUILD_ROOT%{_javadir}/%{name}/empty-dep.jar


###################
# Individual jars #
###################
');

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
[ -d %{_datadir}/%{name}/boot/ ] && find %{_datadir}/%{name}/boot/ -type l -exec rm -f '{}' \; ||:
[ -d %{_datadir}/%{name}/lib/ ] && find %{_datadir}/%{name}/lib/ -type l -exec rm -f '{}' \; ||:

%postun
# FIXME: This doesn't always remove the plugins dir. It seems that rpm doesn't
# honour the Requires(postun) as it should, causing maven to get uninstalled 
# before some plugins are
if [ -d %{_javadir}/%{name} ] ; then rmdir --ignore-fail-on-non-empty %{_javadir}/%{name} >& /dev/null; fi
!."\n");

    $jpp->add_section('files')->push_body(q!%attr(0755,root,root) %{_bindir}/mvn-jpp
%{_datadir}/%{name}/poms/JPP.maven2-empty-dep.pom
%{_javadir}/%{name}/empty-dep.jar!."\n");

};

__END__
