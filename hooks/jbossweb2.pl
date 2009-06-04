#!/usr/bin/perl -w

require 'set_target_15.pl';
require 'set_fix_homedir_macro.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
}

