#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($spec,) = @_;
    # tested in jpp6
    $spec->get_section('package','')->unshift_body('BuildRequires: docbook-dtds'."\n");
};

1;
