#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    # tested in jpp6
    $jpp->get_section('package','')->unshift_body('BuildRequires: docbook-dtds'."\n");
};

1;
