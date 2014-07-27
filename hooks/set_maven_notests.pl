#!/usr/bin/perl -w

push @SPECHOOKS, \&set_maven_notests;

sub set_maven_notests {
    my ($jpp, $alt) = @_;
    $jpp->get_section('build')->subst(qr'^\s*mvn-rpmbuild(?=\s|$)','mvn-rpmbuild -Dmaven.test.skip=true ');
}
