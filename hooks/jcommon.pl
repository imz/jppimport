#!/usr/bin/perl -w

require 'set_quote_source_tag.pl';

push @SPECHOOKS, sub {
    my ($spec, $parent) = @_;
    $spec->get_section('package','')->unshift_body('%def_with repolib'."\n");
};
