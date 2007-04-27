#!/usr/bin/perl -w

$spechook = sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->push_body('Obsoletes: stax-bea <= 1.0-alt1'."\n");
}
