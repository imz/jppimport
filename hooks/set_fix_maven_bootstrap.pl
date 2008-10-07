#!/usr/bin/perl -w

push @SPECHOOKS, \&set_fix_maven_bootstrap;

sub set_fix_maven_bootstrap {
    my ($jpp, $alt) = @_;
	$jpp->applied_block(
	"set_fix_maven_bootstrap",
	sub {
	    foreach my $sec ($jpp->get_sections()) {
		$sec->subst(qr'^Requires:\s*maven2-bootstrap','#Requires: maven2-bootstrap');
	    }
	    });
}

