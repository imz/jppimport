#!/usr/bin/perl -w

require 'set_target_14.pl';

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->add_patch('ws-commons-util-addosgimanifest.patch', STRIP=>0);
}
