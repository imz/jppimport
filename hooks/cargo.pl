#!/usr/bin/perl -w

require 'set_xpp3_min_pom.pl';

push @SPECHOOKS, 
# 1.7, but proved useful in 5.0
sub {
    my ($jpp, $alt) = @_;
    # hack ! geronimo poms !
    $jpp->get_section('package','')->unshift_body('BuildRequires: geronimo-specs-poms'."\n");
    $jpp->get_section('package','')->unshift_body('BuildRequires: checkstyle-optional jakarta-commons-vfs modello-maven-plugin maven-shared maven-shared-file-management'."\n");
    # missing dependency on ant-launcher - fixed in pom
    $jpp->add_patch('cargo-0.9-alt-pom-add-ant-launcher-dependency.patch');
    $jpp->get_section('prep')->push_body(q!
rm ./core/api/generic/src/test/java/org/codehaus/cargo/generic/deployable/DefaultDeployableFactoryTest.java
find ./core/samples/java/src/test/java -name '*.java' -delete
!."\n");

    $jpp->get_section('build')->push_body(q!
# hack to fix strange looking %{name}-core-uberjar (to the state of 1.7; 
# maybe assembly:assembly plugin was misconfigured in 5.0?
mkdir unjar1; pushd unjar1
jar xvf ../core/uberjar/target/%{name}-core-uberjar-%{version}.jar
popd
mv core/uberjar/target/%{name}-core-uberjar-%{version}.jar \
core/uberjar/target/%{name}-core-uberjar-%{version}.jar.bak
mkdir unjar2; pushd unjar2
cp -af ../unjar1/*.jar/* .
jar cf ../core/uberjar/target/%{name}-core-uberjar-%{version}.jar *
popd
!);

}

__END__
# hack for old modello poms
mvn-jpp install:install-file \
        -s $SETTINGS \
        -Dcargo.core.version=0.9 \
        -Dmaven2.jpp.mode=true \
        -Dmaven2.jpp.depmap.file=%{SOURCE6} \
    -Dmaven.repo.local=$MAVEN_REPO_LOCAL \
    -DgroupId=saxpath \
    -DartifactId=saxpath \
    -Dversion=1.0-FCS \
    -Dpackaging=jar \
    -Dfile=$(build-classpath jaxen)
