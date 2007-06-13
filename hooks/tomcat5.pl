#!/usr/bin/perl -w

$spechook = sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->subst(qr'struts >= 0:1.2.7','struts >= 0:1.2.6');
}
