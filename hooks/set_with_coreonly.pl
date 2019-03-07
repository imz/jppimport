#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($spec,) = @_;
    $spec->get_section('package','')->unshift_body('%define _with_coreonly 1'."\n");
}
