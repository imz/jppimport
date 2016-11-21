#!/usr/bin/perl -w

push @SPECHOOKS, 
 sub {
    my ($jpp, $alt) = @_;
    # bug to report
    $jpp->get_section('description','')->subst_body(qr'obsfuscators','obfuscators');
};

