#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    # when upgrade is finished
    $jpp->get_section('package','')->push_body('Obsoletes: qdox16-poms < 1.1'."\n");
}
