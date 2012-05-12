#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('Obsoletes: asm = 2.0-alt0.RC1'."\n");
    $jpp->get_section('install')->map_body(sub {
	my $in=$_;
	return if not s/\%add_to_maven_depmap asm /%add_to_maven_depmap asm2 /;
	$_=$in.$_;
   });

};
