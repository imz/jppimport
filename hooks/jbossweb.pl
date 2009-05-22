#!/usr/bin/perl -w

require 'set_target_15.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
}

