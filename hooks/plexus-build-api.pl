#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    # maven2-208-29
    $jpp->get_section('package','')->unshift_body('BuildRequires: maven2-plugin-resources'."\n");
}
