#!/usr/bin/perl -w

$spechook = sub {
    my ($jpp, $alt) = @_;
    # alt specific? :(
    $jpp->get_section('description')->subst(qr'é','e'); #'é'
}
