#!/usr/bin/perl -w

require 'set_repolib_only.pl';


push @SPECHOOKS, 
 sub {
    my ($jpp, $alt) = @_;
    # bug to report
    $jpp->get_section('description','')->subst(qr'obsfuscators','obfuscators');
};

