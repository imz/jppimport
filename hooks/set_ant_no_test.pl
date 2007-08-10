#!/usr/bin/perl -w

push @SPECHOOKS, \&set_no_ant_test;

sub set_no_ant_test {
    my ($jpp, $alt) = @_;
    $jpp->get_section('build')->subst(qr'ant jar test', 'ant jar');
}
