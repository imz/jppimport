#!/usr/bin/perl -w

require 'set_target_14.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->add_patch('burlap-3.0.8-alt-java5.patch');
}
