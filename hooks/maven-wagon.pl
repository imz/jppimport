#!/usr/bin/perl -w

$spechook = sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('Obsoletes: wagon = 1.0-alt0.3.alpha5'."\n");
    # if with maven2
    $jpp->get_section('package','')->unshift_body('BuildRequires: maven-scm'."\n");
}
