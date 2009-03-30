#!/usr/bin/perl -w

# due to downgrade 1.7 -> 5.0
require 'set_epoch_1.pl';

push @SPECHOOKS, 
 sub {
    my ($jpp, $alt) = @_;
    # bug to report
    $jpp->get_section('description','')->subst(qr'obsfuscators','obfuscators');
};

