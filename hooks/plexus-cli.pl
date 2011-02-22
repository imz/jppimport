#!/usr/bin/perl -w

require 'set_clean_surefire23.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
}
