#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($spec, $parent) = @_;
    # homedir confilct (TODO: report)
    $spec->applied_block(
	"{_datadir}/eclipse/plugins fix",
	sub {
	    map {
		$_->subst(qr'\%{?_datadir}?/eclipse/plugins/org.eclipse.jdt','%{_libdir}/eclipse/dropins/jdt/plugins/org.eclipse.jdt');
		$_->subst(qr'\%{?_datadir}?/eclipse/plugins','%{_libdir}/eclipse/plugins');
	    } $spec->get_section('prep'), $spec->get_section('build');
	});
};

1;
