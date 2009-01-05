#!/usr/bin/perl -w

require 'set_eclipse_core_plugins.pl';
require 'set_target_15.pl';

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
}
