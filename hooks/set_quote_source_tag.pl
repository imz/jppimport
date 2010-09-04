#!/usr/bin/perl -w

#use strict;
use warnings;

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    	$jpp->applied_block(
	"set quote source tag hook",
	sub {
	    my $main = $jpp->get_section('package','');
	    my @body;
	    foreach my $line (@{$main->get_body()}) {
		if ($line=~/^Source\d*:/) {
		    $line=~s/\%/\%\%/g;
		    $jpp->set_applied();
		}
		push @body, $line;
	    }
	    $main->set_body(\@body);
	    });
};
