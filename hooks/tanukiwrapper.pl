#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->add_patch('tanukiwrapper-3.2.3-alt-Makefile.patch', STRIP=>1,INSERT_AFTER=>qr'patch2');
    $jpp->add_patch('tanukiwrapper-3.2.3-alt-add-Makefile-for-armh.patch', STRIP=>2);
    # conflict with our patch: hack around
    $jpp->get_section('prep')->subst(qr'^\%patch3(?=\s|$)','#%patch3');
};
