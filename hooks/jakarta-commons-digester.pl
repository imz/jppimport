#!/usr/bin/perl -w

$spechook = sub {
    my ($jpp, $alt) = @_;
    # ALT Compat provides
#    $jpp->get_section('install')->push_body('ln -s commons-digester.jar $RPM_BUILD_ROOT/%{_javadir}/jakarta-commons-digester.jar'."\n");
    $jpp->get_section('install')->push_body('ln -s jakarta-commons-digester.jar $RPM_BUILD_ROOT/%{_javadir}/commons-digester.jar'."\n");
}
