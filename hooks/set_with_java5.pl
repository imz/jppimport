#!/usr/bin/perl -w

push @SPECHOOKS, \&set_with_java5;

sub set_with_java5 {
    my ($spec,) = @_;
    $spec->get_section('package','')->unshift_body('%define _with_java5 1'."\n");
}
