#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($spec, $parent) = @_;
    $spec->add_patch('tanukiwrapper-3.2.3-alt-Makefile.patch', STRIP=>1,INSERT_AFTER=>qr'patch2');
    $spec->add_patch('tanukiwrapper-3.2.3-alt-add-Makefile-for-armh.patch', STRIP=>2);
    # conflict with our patch: hack around
    $spec->get_section('prep')->subst_body(qr'^\%patch3(?=\s|$)','#%patch3');
};
