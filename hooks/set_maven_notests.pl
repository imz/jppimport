#!/usr/bin/perl -w

push @SPECHOOKS, \&set_maven_notests;

sub set_maven_notests {
    my ($spec, $parent) = @_;
    $spec->get_section('build')->subst(qr'^\s*mvn-rpmbuild(?=\s|$)','mvn-rpmbuild -Dmaven.test.skip=true ');
}
