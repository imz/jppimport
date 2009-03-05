#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('BuildRequires: xpp3 xpp3-minimal'."\n");
#    $jpp->get_section('build')->unshift_body_before(q'
#mvn-jpp install:install-file \
#    -Dmaven.repo.local=$MAVEN_REPO_LOCAL \
#    -DgroupId=xpp3 \
#    -DartifactId=xpp3_min \
#    -Dversion=1.1.4c \
#    -Dpackaging=jar \
#    -Dfile=$(build-classpath xpp3-minimal)
#', qr'mvn-jpp');
    $jpp->get_section('package','')->subst(qr'BuildRequires: xsite','#BuildRequires: xsite');

}
