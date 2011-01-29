#!/usr/bin/perl -w

require 'set_fix_homedir_macro.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
}

