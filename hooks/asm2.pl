#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($spec, $parent) = @_;
    $spec->get_section('package','')->unshift_body('Obsoletes: asm = 2.0-alt0.RC1'."\n");
};
