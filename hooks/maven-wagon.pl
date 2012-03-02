#!/usr/bin/perl -w

require 'set_fix_jpp_depmap_for_qdox12.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;

}
