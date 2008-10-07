#!/usr/bin/perl -w

require 'set_without_maven.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package')->subst(qr'^Requires: maven2-bootstrap','#Requires: maven2-bootstrap');
}
