#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    # homedir confilct (TODO: report)
    $jpp->applied_block(
	"{_datadir}/eclipse/plugins fix",
	sub {
	    map {
		$_->subst(qr'\%{?_datadir}?/eclipse/plugins/org.eclipse.jdt','%{_libdir}/eclipse/dropins/jdt/plugins/org.eclipse.jdt');
		$_->subst(qr'\%{?_datadir}?/eclipse/plugins','%{_libdir}/eclipse/plugins');
	    } $jpp->get_section('prep'), $jpp->get_section('build');
	});
};

1;
