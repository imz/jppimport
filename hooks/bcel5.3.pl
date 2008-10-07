#!/usr/bin/perl -w

push @SPECHOOKS, 
 sub {
    my ($jpp, $alt) = @_;
    # bug to report
    $jpp->get_section('description','')->subst(qr'obsfuscators','obfuscators');
    # hack until maven 2.0.7 will be built (cli hack)
    $jpp->get_section('package','')->unshift_body('BuildRequires: maven2-plugins'."\n");
};

