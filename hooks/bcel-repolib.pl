#!/usr/bin/perl -w

# due to downgrade 1.7 -> 5.0
#require 'set_epoch_1.pl';

require 'set_repolib_only.pl';


push @SPECHOOKS, 
 sub {
    my ($jpp, $alt) = @_;
    # bug to report
    $jpp->get_section('description','')->subst(qr'obsfuscators','obfuscators');
};

