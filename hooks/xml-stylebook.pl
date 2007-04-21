#!/usr/bin/perl -w

$spechook = sub {
    my ($jpp, $alt) = @_;
    # ALT Compat provides
    if (not $jpp->get_section('package','')->match(qr'Provides: stylebook = ')) {
	$jpp->get_section('install')->push_body('ln -s xml-stylebook.jar $RPM_BUILD_ROOT/%{_javadir}/stylebook.jar'."\n");
	$jpp->get_section('package','')->push_body('Provides: stylebook = %{name}-%{version}'."\n");
	$jpp->get_section('package','')->push_body('Obsoletes: stylebook < 1.0-alt1'."\n");
	$jpp->get_section('files','')->unshift_body('%{_javadir}/stylebook.jar'."\n");

	#$jpp->get_section('package','')->set_tag('Release','alt1_0.b3_xalan2.2jpp1.7');
    }
}
