#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    # will be deprecated in jpp 6.0
    $jpp->get_section('package','')->unshift_body('BuildRequires: bcel ant-bcel'."\n");
}
