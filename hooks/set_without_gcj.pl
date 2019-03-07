#!/usr/bin/perl -w

push @SPECHOOKS, \&set_without_gcj;

sub set_without_gcj {
    my ($spec,) = @_;
    $spec->get_section('package','')->unshift_body('%define _without_gcj 1'."\n");
}
