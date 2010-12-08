#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('BuildRequires: xml-commons-jaxp-1.3-apis'."\n");
    $jpp->get_section('prep')->subst(qr'xml-commons-apis-ext.jar','xml-commons-jaxp-1.3-apis-ext.jar');
    $jpp->get_section('install')->subst(qr'xml-commons-apis-ext.jar','xml-commons-jaxp-1.3-apis-ext.jar');
};

