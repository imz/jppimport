#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->applied_block(
	"set_bcond convert hook",
	    sub {
		my $mainsec=$jpp->get_section('package','');
		$mainsec->subst(qr'^%define bcond_without\(\).*', '#define bcond_without()'."\n");
		$mainsec->subst(qr'^%define bcond_with\(\).*', '#define bcond_with()'."\n");
		$mainsec->subst(qr'^%define without\(\).*', '#define without()'."\n");
		$mainsec->subst(qr'^%define with\(\).*', '#define with()'."\n");
		foreach my $sec ($jpp->get_sections()) {
		    $sec->subst(qr'^%bcond_without ', '%def_without ');
		    $sec->subst(qr'^%bcond_with ', '%def_with ');
		    $sec->subst(qr'^%if\s+without', '%if_without');
		    $sec->subst(qr'^%if\s+with', '%if_with');
		}
	    }
	);
}
;
