#!/usr/bin/perl -w

push @SPECHOOKS, 
 sub {
    my ($spec,) = @_;
    $spec->get_section('package','')->push_body('Obsoletes: stax-bea <= 1.0-alt1'."\n");
}
