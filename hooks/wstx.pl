#!/usr/bin/perl -w

#require 'set_repolib_only.pl';

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
	$jpp->get_section('package','')->unshift_body('BuildRequires: bcel ant-bcel'."\n");
}
