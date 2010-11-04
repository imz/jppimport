#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    # will be deprecated in jpp 6.0
    $jpp->get_section('package','')->unshift_body('BuildRequires: bcel ant-bcel'."\n");
    
    $jpp->get_section('package','')->unshift_body('%define _with_repolib 1'."\n");
    $jpp->get_section('package','')->unshift_body('%define with_repolib 1'."\n");
    
    # do we need it?
    #$jpp->get_section('package','')->push_body('Provides: wstx32 = %version'."\n");
    #$jpp->get_section('package','')->push_body('Obsoletes: wstx32 < %version'."\n");
}
