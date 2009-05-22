#!/usr/bin/perl -w

#require 'set_target_14.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->add_patch('dynaop-1.0-beta-alt-java5.patch');
}
