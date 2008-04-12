#!/usr/bin/perl -w

require 'set_bin_755.pl';

$spechook = sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body("BuildRequires: xml-commons-resolver\n");
    $jpp->get_section('package','')->push_body("Provides: xerces-j = %version-%release\n");
    $jpp->get_section('package','')->push_body("Obsoletes: xerces-j <= 2.9.0-alt4\n");
    $jpp->get_section('install')->push_body('ln -s xerces-j2.jar $RPM_BUILD_ROOT%_javadir/xerces-j.jar'."\n");
    $jpp->get_section('files','')->push_body('%_javadir/xerces-j.jar'."\n");
}
