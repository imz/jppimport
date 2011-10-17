#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    # ALT Compat provides
    if (not $jpp->get_section('package','')->match_body(qr'Provides: stylebook = ')) {
	# NOTE: symlinks seems to be no more needed
	$jpp->get_section('install')->push_body('ln -s xml-stylebook.jar $RPM_BUILD_ROOT/%{_javadir}/stylebook.jar'."\n");
	$jpp->get_section('package','')->push_body('Provides: stylebook = %{version}'."\n");
	$jpp->get_section('package','')->push_body('Obsoletes: stylebook < 1.0-alt1'."\n");
	$jpp->get_section('files','')->unshift_body('%{_javadir}/stylebook.jar'."\n");
    }
}
