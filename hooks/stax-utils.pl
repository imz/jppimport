#!/usr/bin/perl -w

require 'set_split_gcj_support.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->add_patch('stax-utils-0.0-javadoc-exclude.patch');
};

1;
