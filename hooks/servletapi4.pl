#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    # ALT Compat provides
    if (not $jpp->get_section('package','')->match(qr'Provides: jakarta-servletapi4 = ')) {
	$jpp->get_section('install')->push_body('ln -s servletapi4.jar $RPM_BUILD_ROOT/%{_javadir}/jakarta-servletapi4.jar'."\n");
	$jpp->get_section('package','')->push_body('Provides: jakarta-servletapi4 = %{name}-%{version}'."\n");
	$jpp->get_section('package','')->push_body('Obsoletes: jakarta-servletapi4 < 4.0.0-alt1'."\n");
	$jpp->get_section('files','')->unshift_body('%{_javadir}/jakarta-servletapi4.jar'."\n");
    }

# todo: make an extension
    $jpp->get_section('install')->push_body('
cat >>$RPM_BUILD_ROOT/%_altdir/servletapi_%{name}<<EOF
%{_javadir}/servletapi.jar	%{_javadir}/%{name}-%{version}.jar	20300
EOF
');
    $jpp->get_section('files')->push_body('%_altdir/servletapi_*'."\n");
    $jpp->get_section('post')->push_body('%register_alternatives servletapi_%{name}'."\n");
    $jpp->get_section('postun')->push_body('%unregister_alternatives servletapi_%{name}'."\n");
}
