#!/usr/bin/perl -w

push @SPECHOOKS, 

# todo: add fragments for checkstyle-optional?

sub {
    my ($jpp, $alt) = @_;
    # hack ! geronimo poms !
    $jpp->get_section('package','')->unshift_body('BuildRequires: geronimo-specs-poms'."\n");
    $jpp->get_section('package','')->unshift_body('BuildRequires: checkstyle-optional jakarta-commons-vfs maven-plugin-modello maven-shared maven-shared-file-management'."\n");
    # missing dependency on ant-launcher - fixed in pom
    $jpp->add_patch('cargo-0.9-alt-pom-add-ant-launcher-dependency.patch');
    $jpp->get_section('prep')->push_body(q!
rm ./core/api/generic/src/test/java/org/codehaus/cargo/generic/deployable/DefaultDeployableFactoryTest.java
find ./core/samples/java/src/test/java -name '*.java' -delete
!."\n");

}