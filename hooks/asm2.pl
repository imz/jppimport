#!/usr/bin/perl -w

$spechook = sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('Obsoletes: asm = 2.0-alt0.RC1'."\n");

    # TODO: remove asm2-parent entry
}
