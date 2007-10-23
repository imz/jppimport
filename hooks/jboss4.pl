#!/usr/bin/perl -w

require 'set_with_coreonly.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('BuildRequires: jakarta-crimson'."\n");
    $jpp->add_patch('jboss-4.0.3SP1-alt-ant17support.patch');
}
