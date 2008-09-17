#!/usr/bin/perl -w

push @SPECHOOKS, 
 sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->push_body('Obsoletes: stax-bea <= 1.0-alt1'."\n");
}
