#!/usr/bin/perl -w

$spechook = sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('Obsoletes: gnu-trove = 1.1-alt0.1b4'."\n");
}
