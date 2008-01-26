#!/usr/bin/perl -w

#jpp5.0

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('BuildRequires: hsqldb'."\n");
};
