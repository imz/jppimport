#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->subst_if('jetty','jetty6',qr'Requires:');
    $jpp->get_section('package','')->unshift_body('BuildRequires: maven2-plugin-dependency maven-shared-filtering'."\n");
}
