#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    my $desktop_package='';
    my $secptr=$jpp->get_sections();
    foreach my $sec (@$secptr) {
	my $t = $sec->get_type();
	if ($t eq 'files') {
	    if ($sec->match(qr'^%{_datadir}/applications')) {
		$desktop_package=$sec->get_package();
		last;
	    }
	}
    }
    $jpp->add_section('post',$desktop_package)->push_body(q'%update_menus
');
    $jpp->add_section('postun',$desktop_package)->push_body(q'%clean_menus
');
};

1;
