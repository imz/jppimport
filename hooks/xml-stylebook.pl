#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($spec, $parent) = @_;
    # ALT Compat provides
    if (not $spec->get_section('package','')->match_body(qr'Provides: stylebook = ')) {
	# NOTE: symlinks seems to be no more needed
	$spec->get_section('install')->push_body('ln -s xml-stylebook.jar $RPM_BUILD_ROOT/%{_javadir}/stylebook.jar'."\n");
	$spec->get_section('package','')->push_body('Provides: stylebook = %{version}'."\n");
	$spec->get_section('package','')->push_body('Obsoletes: stylebook < 1.0-alt1'."\n");
	$spec->get_section('files','')->unshift_body('%{_javadir}/stylebook.jar'."\n");
    }
}
