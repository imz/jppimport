#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->add_patch('ws-commons-util-addosgimanifest.patch', STRIP=>0);
}
