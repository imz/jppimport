#!/usr/bin/perl -w

require 'set_target_15.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    # homedir confilct (TODO: report)
    $jpp->applied_block(
	"homedir confilct",
	sub {
	    map {
		$_->subst(qr'\%{?_datadir}?/eclipse/plugins/org.eclipse.jdt','%{_libdir}/eclipse/dropins/jdt/plugins/org.eclipse.jdt');
		$_->subst(qr'\%{?_datadir}?/eclipse/plugins','%{_libdir}/eclipse/plugins');
	    } $jpp->get_section('prep'), $jpp->get_section('build');
	    $jpp->get_section('package','')->subst(qr'jpackage-compat','jpackage-1.6-compat', qr'Requires:');
	});
};

1;
