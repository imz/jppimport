#!/usr/bin/perl -w

require 'set_epoch_1.pl';
require 'set_target_14.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->push_body('Provides: junit = 0:%{version}'."\n");
};

1;
