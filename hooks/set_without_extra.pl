#!/usr/bin/perl -w

push @SPECHOOKS, \&set_without_extra;

sub set_without_extra {
    my ($spec, $parent) = @_;
    $spec->get_section('package','')->unshift_body('%define _without_extra 1'."\n");
}
