#!/usr/bin/perl -w

$spechook = sub {
    my ($jpp, $alt) = @_;
    # bug to report
    $jpp->get_section('package','')->subst(qr'obsfuscators','obfuscators');
};

