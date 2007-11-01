#!/usr/bin/perl -w

require 'set_target_14.pl';

$spechook = \&fix_mail;

# until old jaf will be in Sisyphus
sub fix_mail {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('Obsoletes: javamail = 1.3.1-alt2'."\n");
    $jpp->get_section('package','')->unshift_body('Obsoletes: javamail = 1.3.1-alt1'."\n");
}

1;
