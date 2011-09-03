#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    my $ex=$jpp->get_section('package','examples');
    $ex->push_body('BuildArch: noarch'."\n") if $ex;
}
