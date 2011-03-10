#!/usr/bin/perl -w

push @SPECHOOKS, 

sub  {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->push_body('Provides: msv-msv = %version-%release'."\n");
    $jpp->get_section('package','')->push_body('Obsoletes: msv-msv < %version-%release'."\n");
    $jpp->get_section('description','xsdlib')->push_body('
 Sun XML Datatypes Library. An implementation of W3C XML Schema Part 2.
');
}
