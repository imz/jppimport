#!/usr/bin/perl -w

$spechook = \&set_bootstrap_nohook;

# report design of cglib-hook as bug

sub set_bootstrap_nohook {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('%define _without_hook 1'."\n");
    $jpp->get_section('package','nohook')->push_body('Provides: cglib = 0:%{version}'."\n");
    $jpp->get_section('install')->push_body('ln -s %{name}-nohook.jar $RPM_BUILD_ROOT%{_javadir}/%{name}.jar'."\n");
    $jpp->get_section('files','nohook')->push_body('%{_javadir}/%{name}.jar'."\n");
    $jpp->set_changelog('- imported with jppimport script; note: bootstrapped version');
}
