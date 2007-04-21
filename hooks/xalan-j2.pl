#!/usr/bin/perl -w

$spechook = sub {
    my ($jpp, $alt) = @_;
# bugfix; to be commited in bugzilla
    $jpp->get_section('files','manual')->subst(qr'\%doc build/docs/\*','%doc --no-dereference build/docs/*');

    # 2 changelogs (jppbug, to be commited in bugzilla
    my $count_changelogs=0;
    for (my $i=0; $i<@{$jpp->get_sections()}; $i++) {
	if ($jpp->get_sections()->[$i]->get_type() eq 'changelog') {
	    if ($count_changelogs>0) {
		@{$jpp->get_sections()}[$i..$#{$jpp->get_sections()}-1]=@{$jpp->get_sections()}[$i+1..$#{$jpp->get_sections()}];
		$#{$jpp->get_sections()}--;
	    }
	    $count_changelogs++;
	}
    }

    # ALT Compat provides
    if (not $jpp->get_section('package','')->match(qr'Provides: xalan-j = ')) {
	#$jpp->get_section('install')->push_body('ln -s xalan-j2.jar $RPM_BUILD_ROOT/%{_javadir}/xalan-j.jar'."\n");
	#$jpp->get_section('install')->push_body('ln -s xalan-j2.jar $RPM_BUILD_ROOT/%{_javadir}/serializer.jar'."\n");
	#$jpp->get_section('package','')->push_body('Provides: xalan-j = %{name}-%{version}'."\n");
	#$jpp->get_section('package','')->push_body('Obsoletes: xalan-j < 2.7.0-alt3_1'."\n");
	#$jpp->get_section('files','')->unshift_body('%{_javadir}/xalan-j.jar'."\n");
	#$jpp->get_section('files','')->unshift_body('%{_javadir}/serializer.jar'."\n");
    }
    #$jpp->set_changelog('- removed provides for xalan-j (no more needed)')

    # hack around broken deps
    $jpp->get_section('package','')->subst(qr'BuildRequires:\s*java-devel','##BuildRequires: java-devel');
}
