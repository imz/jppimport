#!/usr/bin/perl -w

require 'set_quote_source_tag.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
};
