#!/usr/bin/perl -w

require 'set_without_maven.pl';
require 'set_without_demo.pl';
require 'set_target_14.pl';

#$spechook = \&remove_j;

sub remove_j {
    my ($jpp, $alt) = @_;
    # hack around broken deps
    $jpp->get_section('package','')->subst(qr'BuildRequires:\s*mockobjects','##BuildRequires: mockobjects');
    $jpp->get_section('package','')->subst(qr'Requires:\s*mockobjects','##Requires: mockobjects');
    $jpp->get_section('prep')->subst(qr'mockobjects-core',' ');
    $jpp->get_section('prep')->push_body('rm -rf modules/mockobjects'."\n");
}
