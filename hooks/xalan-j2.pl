#!/usr/bin/perl -w

require 'set_target_14.pl';
require 'set_manual_no_dereference.pl';

$spechook = sub {
    my ($jpp, $alt) = @_;

    # 2 changelogs (jppbug, to be commited in bugzilla
    my $count_changelogs=0;
    my $secptr=$jpp->get_sections_ref();
    for (my $i=0; $i<@$secptr; $i++) {
	if ($secptr->[$i]->get_type() eq 'changelog') {
	    if ($count_changelogs>0) {
		@{$secptr}[$i..$#{$secptr}-1]=@{$secptr}[$i+1..$#{$secptr}];
		$#{$secptr}--;
	    }
	    $count_changelogs++;
	}
    }

    # ALT Compat provides
    if (not $jpp->get_section('package','')->match(qr'Provides: xalan-j = ')) {
	$jpp->get_section('install')->push_body('ln -s xalan-j2.jar $RPM_BUILD_ROOT/%{_javadir}/xalan-j.jar'."\n");
	$jpp->get_section('install')->push_body('ln -s xalan-j2-serializer.jar $RPM_BUILD_ROOT/%{_javadir}/serializer.jar'."\n");
	$jpp->get_section('package','')->push_body('Provides: xalan-j = %{name}-%{version}'."\n");
	$jpp->get_section('package','')->push_body('Obsoletes: xalan-j <= 2.7.0-alt3'."\n");
	$jpp->get_section('files','')->unshift_body('%{_javadir}/xalan-j.jar'."\n");
	$jpp->get_section('files','')->unshift_body('%{_javadir}/serializer.jar'."\n");

	$jpp->get_section('files','javadoc')->unshift_body('%{_javadocdir}/xalan-j'."\n");

	$jpp->get_section('install')->push_body('ln -s xalan-j2 $RPM_BUILD_ROOT/%{_javadocdir}/xalan-j'."\n");
    }
    $jpp->set_changelog('- rebuild on x86_64; added explicit source and target 1.4
- obsoletes: xalan-j');

    # 1.5 hack
    &set_target_14($jpp, $alt);
}
