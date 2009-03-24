#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->subst(qr'docbook-xsl-java-saxon', 'docbook-xsl-saxon');
}
