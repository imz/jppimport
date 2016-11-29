#!/usr/bin/perl -w

push @SPECHOOKS, \&set_without_tests;
sub set_without_tests {
    my ($spec, $parent) = @_;
    $spec->get_section('package','')->unshift_body('%define _without_tests 1'."\n");
}
