#!/usr/bin/perl -w

push @SPECHOOKS, 

sub  {
    my ($jpp, $alt) = @_;
#    $jpp->get_section('package','xsdlib')->subst(qr'Provides:\s*xsdlib',
#					'Provides: xsdlib = 2.2-alt1');
#    $jpp->get_section('package','xsdlib')->subst(qr'Obsoletes:\s*xsdlib',
#					'Obsoletes: xsdlib = 2.2-alt0.2');
}
