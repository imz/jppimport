#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->unshift_body_before(q'
mvn-jpp install:install-file \
    -Dmaven.repo.local=$MAVEN_REPO_LOCAL \
    -DgroupId=xpp3 \
    -DartifactId=xpp3_min \
    -Dversion=1.1.3.4.O \
    -Dpackaging=jar \
    -Dfile=$(build-classpath xpp3-minimal)
', qr'mvn-jpp');

}
