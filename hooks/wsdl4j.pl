#!/usr/bin/perl -w

require 'set_add_fc_osgi_manifest.pl';

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
}
