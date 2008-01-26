#!/usr/bin/perl -w

#jpp5.0

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('BuildRequires: hsqldb'."\n");
    $jpp->get_section('package','')->subst_if('lucene','lucene1',qr'Requires:');
};
