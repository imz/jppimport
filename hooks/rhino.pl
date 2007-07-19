#!/usr/bin/perl -w

$spechook = \&fix_etc_rhino_conf;

sub fix_etc_rhino_conf {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('AutoReq: nosh'."\n");
}

1;
