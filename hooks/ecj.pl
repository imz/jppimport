#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('Obsoletes: ecj-standalone <= 3.4.2-alt4_0jpp6'."\n");

    # ecj should not have osgi dependencies.
    $jpp->get_section('package','')->push_body('
AutoReq: yes, noosgi
AutoProv: yes, noosgi
');
};
