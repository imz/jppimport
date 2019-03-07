#!/usr/bin/perl -w

#require 'set_osgi.pl';

push @SPECHOOKS, sub {
    my ($spec,) = @_;
    $spec->get_section('package','')->unshift_body('%filter_from_requires /osgi(org.apache.ant*/d'."\n");
}
