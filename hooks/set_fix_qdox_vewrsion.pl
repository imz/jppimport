#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->applied_block(
	"qdox version hook",
	sub {
	    foreach my $section ($jpp->get_sections()) {
		next if $section->get_type() ne 'package';
		$section->subst_if(qr'<\s*0:1.6.2','',qr'Requires:.+qdox');
	    }
	}
	);
}
