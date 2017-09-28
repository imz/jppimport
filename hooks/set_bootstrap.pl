#!/usr/bin/perl -w

push @SPECHOOKS, \&set_bootstrap;

sub set_bootstrap {
    my ($spec, $parent) = @_;
    $spec->get_section('package','')->unshift_body('%define _bootstrap 1'."\n");
    $spec->get_section('package','')->unshift_body('%define _with_bootstrap 1'."\n");
    # for fedora
    $spec->get_section('package','')->subst_body(qr'%define\s+bootstrap\s+0','%define bootstrap 1');
    $spec->set_default_changelog('- imported with jppimport script; note: bootstrapped version');
}
