#!/usr/bin/perl -w

require 'set_quote_source_tag.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('%def_with repolib'."\n");
};
