#!/usr/bin/perl -w

$spechook = sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('install')->push_body('chmod 755 $RPM_BUILD_ROOT%{_bindir}/saxon'."\n");
}
