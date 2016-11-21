#!/usr/bin/perl -w

require 'set_target_15.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('BuildRequires: dom4j'."\n");
}
