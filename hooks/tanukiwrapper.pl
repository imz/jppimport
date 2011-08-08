#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->add_patch('tanukiwrapper-3.2.3-alt-Makefile.patch', STRIP=>1);
    # conflict with our patch: hack around
    $jpp->get_section('prep')->subst('%patch3','#%patch3');
    $jpp->get_section('prep')->push_body_after('%patch33 -p1'."\n", qr'%patch2');
};
