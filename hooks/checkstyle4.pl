#!/usr/bin/perl -w

require 'set_manual_no_dereference.pl';
#require 'set_target_14.pl';

push @SPECHOOKS, 
 sub {
    my ($jpp, $alt) = @_;
#    $jpp->get_section('package','')->unshift_body('BuildRequires: ant-optional'."\n");
    # hack! disabled tests! (xerces-j-2.9.0; tests passed with xerces-j-2.8.x)
#    $jpp->get_section('build')->subst(qr' run.tests ',' ');
}
