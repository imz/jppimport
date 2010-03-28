#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    # do not build with javacc 4; let us use javacc3
    # TODO: patch ant to fetch javacc3 after javacc.
    $jpp->get_section('package','')->subst(qr'BuildRequires: javacc','BuildRequires: javacc3');
    $jpp->get_section('prep')->push_body(q!
ln -s $(build-classpath javacc3) javacc.jar
!);
    $jpp->get_section('build')->subst(qr'Djavacc.home=\%{_javadir}','Djavacc.home=`pwd`');
}
