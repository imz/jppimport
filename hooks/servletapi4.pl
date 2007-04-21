#!/usr/bin/perl -w

$spechook = sub {
    my ($jpp, $alt) = @_;
    # ALT Compat provides
    if (not $jpp->get_section('package','')->match(qr'Provides: jakarta-servletapi4 = ')) {
	$jpp->get_section('install')->push_body('ln -s servletapi4.jar $RPM_BUILD_ROOT/%{_javadir}/jakarta-servletapi4.jar'."\n");
	$jpp->get_section('package','')->push_body('Provides: jakarta-servletapi4 = %{name}-%{version}'."\n");
	$jpp->get_section('package','')->push_body('Obsoletes: jakarta-servletapi4 < 4.0.0-alt1'."\n");
	$jpp->get_section('files','')->unshift_body('%{_javadir}/jakarta-servletapi4.jar'."\n");
    }
}
