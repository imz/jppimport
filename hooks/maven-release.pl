#!/usr/bin/perl -w

#require 'set_without_maven.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    # maven-release-4
#    $jpp->get_section('package')->subst(qr'^Requires: maven2-bootstrap','#Requires: maven2');
    $jpp->get_section('package')->push_body('Provides: maven2-plugin-release = 2.0.7'."\n");
    $jpp->get_section('package','',)->push_body('BuildRequires: modello-maven-plugin saxpath'."\n");

    # bug? to report in jpp5 when _without_maven
    # check after rebuild world
    $jpp->get_section('build')->subst(qr'plexus/classworlds', 'plexus/classworlds classworlds');

    # maven-release-4-2jpp
    $jpp->add_source('maven-release-4-components.xml',NUMBER=>44);
    $jpp->get_section('install')->push_body('
# jar repack hack due to different/broken output of plexus components
mkdir repack
pushd repack
jar xf $RPM_BUILD_ROOT%{_javadir}/%{name}/manager-%{manager_version}.jar
cp %{SOURCE44} META-INF/plexus/components.xml
jar cf $RPM_BUILD_ROOT%{_javadir}/%{name}/manager-%{manager_version}.jar META-INF org
popd
');
    
}

__END__
skipped tests as there were missing deps in pom
