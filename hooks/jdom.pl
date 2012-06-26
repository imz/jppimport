#!/usr/bin/perl -w

require 'set_add_fc_osgi_manifest.pl';

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('install')->unshift_body_after(qr'add_to_maven_depmap','%add_to_maven_depmap jdom jdom %{version} JPP %{name}'."\n");
}
