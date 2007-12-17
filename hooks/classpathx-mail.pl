#!/usr/bin/perl -w

# target_14
require 'set_sasl_hook.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->subst(qr'BuildRequires:\s*jaf','BuildRequires: classpathx-jaf');
}
