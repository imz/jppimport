#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    # xpp3_min is referred in xstream -> breaks xsite build
    #maven2/poms/JPP-xstream-parent.pom:        <version>1.1.4c</version>
    $jpp->get_section('build')->unshift_body2_before(q!
mvn-jpp \
        -e \
        -s $(pwd)/settings.xml \
        -Dmaven2.jpp.mode=true \
        -Dmaven2.jpp.depmap.file=%{SOURCE2} \
        -Dmaven.repo.local=$MAVEN_REPO_LOCAL \
        install:install-file -DgroupId=xpp3 -DartifactId=xpp3_min \
        -Dversion=1.1.4c -Dpackaging=jar -Dfile=$(build-classpath xpp3)

!,qr'^\s*mvn-jpp');
}
