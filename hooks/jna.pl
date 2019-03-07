#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($spec,) = @_;
    my $ex=$spec->get_section('package','examples');
    $ex->push_body('BuildArch: noarch'."\n") if $ex;
}
