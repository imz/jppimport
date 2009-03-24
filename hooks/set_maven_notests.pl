#!/usr/bin/perl -w

push @SPECHOOKS, \&set_maven_notests;

sub set_maven_notests {
    my ($jpp, $alt) = @_;
    $jpp->get_section('build')->subst(qr'^\s*mvn-jpp(?=\s|$)','mvn-jpp -Dmaven.test.skip=true ');
}
