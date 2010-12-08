#!/usr/bin/perl -w

require 'set_manual_no_dereference.pl';
require 'set_add_fc_osgi_manifest.pl';
require 'set_dos2unix_scripts.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;

    $jpp->get_section('prep')->push_body('# xerces-j2 2.9.1 in repolib
if grep 2.7.1 %{SOURCE1}; then
subst s,2.7.1,2.9.1, %{SOURCE1}
else
echo Hook is deprecated!!! delete it.
fi
');

    # ALT Compat provides
    if (not $jpp->get_section('package','')->match(qr'Provides: xalan-j = ')) {
	$jpp->get_section('install')->push_body('ln -s xalan-j2.jar $RPM_BUILD_ROOT/%{_javadir}/xalan-j.jar'."\n");
#	$jpp->get_section('install')->push_body('ln -s xalan-j2-serializer.jar $RPM_BUILD_ROOT/%{_javadir}/serializer.jar'."\n");
	$jpp->get_section('package','')->push_body('Provides: xalan-j = %{name}-%{version}'."\n");
	$jpp->get_section('package','')->push_body('Obsoletes: xalan-j <= 2.7.0-alt3'."\n");
	$jpp->get_section('files','')->unshift_body('%{_javadir}/xalan-j.jar'."\n");
#	$jpp->get_section('files','')->unshift_body('%{_javadir}/serializer.jar'."\n");

	$jpp->get_section('files','javadoc')->unshift_body('%{_javadocdir}/xalan-j'."\n");

	$jpp->get_section('install')->push_body('ln -s xalan-j2 $RPM_BUILD_ROOT/%{_javadocdir}/xalan-j'."\n");
    }
};

__END__
