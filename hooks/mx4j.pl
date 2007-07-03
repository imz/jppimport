#!/usr/bin/perl -w

require 'set_bootstrap.pl';
require 'set_target_14.pl';

$spechook = sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->subst(qr'jsse >= 0:1.0.2-6jpp','jsse');
    $jpp->get_section('package','')->subst(qr'jce >= 0:1.2.2','jce');
}
