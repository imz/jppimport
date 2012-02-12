#!/usr/bin/perl -w

# due to out of memory errors
push @SPECHOOKS, 
 sub {
    my ($jpp, $alt) = @_;
    # todo: report?
    $jpp->get_section('build')->subst(qr!install javadoc:javadoc!,'javadoc:javadoc');
    $jpp->get_section('build')->unshift_body_before(qr'^mvn-jpp',q!
mvn-jpp \
        -e \
        -s $SETTINGS \
        -Dmaven2.jpp.depmap.file=%{SOURCE2} \
        -Dmaven.repo.local=$MAVEN_REPO_LOCAL \
        -Dmaven.test.skip=true \
        -Dmaven.test.failure.ignore=true \
        install
!);
}
#-Dmaven.javadoc.additionalparam=-J-Xmx256m \
