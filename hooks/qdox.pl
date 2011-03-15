#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->push_body('Provides: qdox16-poms = %{version}'."\n");
    $jpp->get_section('package','')->push_body('Obsoletes: qdox16-poms < %{version}'."\n");
}
