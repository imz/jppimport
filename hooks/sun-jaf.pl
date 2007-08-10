#!/usr/bin/perl -w

$spechook = \&fix_jaf;

# until old jaf will be in Sisyphus
sub fix_jaf {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('Obsoletes: jaf = 1.0.2-alt2'."\n");
}

1;
