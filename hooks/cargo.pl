#!/usr/bin/perl -w

require 'set_jetty6_servlet_25_api.pl';
#
push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    #$jpp->get_section('package','')->subst_if(qr'maven-plugin-modello','modello-maven-plugin',qr'Requires:');
    $jpp->get_section('package','')->exclude(qr'maven-plugin-modello');
    $jpp->get_section('package','')->subst_if(qr'modello','modello10',qr'Requires:');
}

__END__
