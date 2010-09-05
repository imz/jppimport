#!/usr/bin/perl -w

require 'set_epoch_1.pl';
# TEMPORARY
require 'set_target_15.pl';

push @SPECHOOKS, 

sub  {
    my ($jpp, $alt) = @_;
#    $jpp->get_section('package','')->push_body('Provides: jakarta-commons-cli-1'."\n");
#    $jpp->get_section('package','')->push_body('Obsoletes: jakarta-commons-cli-1 <= 1.0-alt2'."\n");
}
