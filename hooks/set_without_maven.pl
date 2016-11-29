#!/usr/bin/perl -w

push @SPECHOOKS, \&set_without_maven;
#$spechook = \&set_without_maven;

sub set_without_maven {
    my ($spec, $parent) = @_;
    $spec->get_section('package','')->unshift_body('%define _without_maven 1
');
    # helped for maven surefire
    # not yet enabled (no other customers are known)
    #$spec->get_section('package','')->exclude(qr'^\%define with_maven \%{!\?_without_maven:1}\%{\?_without_maven:0}\s*$');

}
