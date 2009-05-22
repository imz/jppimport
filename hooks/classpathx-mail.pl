#!/usr/bin/perl -w

# target_14
require 'set_sasl_hook.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->push_body('# required for fedora tomcat
Provides: javamail = 0:1.3.1
Provides: javamail-monolithic = 0:1.3.1
');1
#    $jpp->get_section('package','')->subst(qr'BuildRequires:\s*jaf','BuildRequires: classpathx-jaf');
}
