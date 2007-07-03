#!/usr/bin/perl -w

require 'set_without_maven.pl';

# hack until servletapi5 will be obsolete

push @SPECHOOKS, \&set_without_servletapi5;

sub set_without_servletapi5 {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->subst(qr'^BuildRequires: servletapi5', '##BuildRequires: servletapi5');
    $jpp->get_section('package','')->subst(qr'^Requires: servletapi5', '##Requires: servletapi5');
}
