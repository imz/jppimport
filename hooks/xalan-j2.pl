#!/usr/bin/perl -w

require 'set_target_14.pl';
require 'set_manual_no_dereference.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;

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
    # 2 changelogs (jppbug, to be commited in bugzilla
    my $count_changelogs=0;
    my @newsec;
    foreach my $sec ($jpp->get_sections()) {
	if ($sec->get_type() eq 'changelog') {
	    push @newsec, $sec unless $count_changelogs++;
	} else {
	    push @newsec, $sec;
	}
    }
    $jpp->set_sections(\@newsec);
