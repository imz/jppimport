#!/usr/bin/perl -w

#use strict;
use warnings;

push @SPECHOOKS, 
sub {
    my ($spec, $parent) = @_;
    	$spec->applied_block(
	"set quote source tag hook",
	sub {
	    my $main = $spec->get_section('package','');
	    my @body;
	    foreach my $line (@{$main->get_bodyref()}) {
		if ($line=~/^Source\d*:/) {
		    $line=~s/\%/\%\%/g;
		    $spec->set_applied();
		}
		push @body, $line;
	    }
	    $main->set_body(\@body);
	    });
};
