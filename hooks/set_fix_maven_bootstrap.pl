#!/usr/bin/perl -w

push @SPECHOOKS, \&set_fix_maven_bootstrap;

sub set_fix_maven_bootstrap {
    my ($spec,) = @_;
	$spec->applied_block(
	"set_fix_maven_bootstrap",
	sub {
	    foreach my $sec ($spec->get_sections()) {
		$sec->subst_body(qr'^Requires:\s*maven2-bootstrap','#Requires: maven2-bootstrap');
	    }
	    });
}

