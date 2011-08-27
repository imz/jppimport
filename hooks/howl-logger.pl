#!/usr/bin/perl -w

# due to out of memory errors
push @SPECHOOKS, 
 sub {
    my ($jpp, $alt) = @_;
    # todo: report?
    $jpp->get_section('build')->subst(qr!jar:jar javadoc:generate!,'javadoc:generate');
    $jpp->get_section('build')->unshift_body_before(qr'^maven',q!
maven \
        -Dmaven.home.local=$(pwd)/.maven \
        -Dmaven.repo.remote=file:/usr/share/maven/repository \
        -Dmaven.test.failure.ignore=true \
        -Dmaven.javadoc.source=1.4 \
        jar:jar
!);
}
#-Dmaven.javadoc.additionalparam=-J-Xmx256m \
