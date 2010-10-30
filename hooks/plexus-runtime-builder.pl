#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->copy_to_sources('plexus-runtime-builder-1.0-alt-maven207.patch');
    $jpp->get_section('package','')->subst(qr'\%{name}-maven204.patch','plexus-runtime-builder-1.0-alt-maven207.patch');
#    $jpp->get_section('package','')->unshift_body('BuildRequires: maven2-plugins'."\n");
}
