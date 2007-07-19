#!/usr/bin/perl -w

$spechook = \&fix_junit_epoch;

sub fix_junit_epoch {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->subst(qr'= 0:3.8.2','= 3.8.2');
    $jpp->get_section('package','')->subst(qr'=\s*0:1.6.5','>= 1.6.5');
    $jpp->get_section('package','')->unshift_body('BuildRequires: ant-junit'."\n");
}

1;
