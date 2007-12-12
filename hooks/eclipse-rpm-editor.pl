#!/usr/bin/perl -w

require 'set_fix_eclipse_dep.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    # altbug#13596
    $jpp->get_section('package','')->subst_if(qr'0.81','0.80',qr'Requires:\s*rpmlint');
};
