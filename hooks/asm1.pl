#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('install')->map_body(sub {
	my $in=$_;
	return if not s/\%add_to_maven_depmap asm /%add_to_maven_depmap asm1 /;
	$_=$in.$_;
   });

};
