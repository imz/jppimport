#!/usr/bin/perl -w

require 'set_fix_homedir_macro.pl';
require 'add_missingok_config.pl';

#TODO as a hook
#require 'set_maven_test_skip.pl';
#subst 's,mvn-jpp ,mvn-jpp -Dmaven.test.skip=true ,' *.spec

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->subst_if(qr'< 0:1\.6\.2', '>= 1.6.1',qr'Requires:');
    #$jpp->get_section('package','')->subst_if(qr'wadi2', 'wadi-core',qr'Requires:');
    #%define appdir /srv/jetty6
    $jpp->get_section('package','')->subst_if(qr'/srv/jetty6', '/var/lib/jetty6',qr'\%define');

    # requires from nanocontainer-webcontainer :(
    $jpp->get_section('package','jsp-2.0')->push_body('Provides: jetty6-jsp-2.0-api = %version'."\n");

    &add_missingok_config($jpp, '/etc/default/%{name}','');
    &add_missingok_config($jpp, '/etc/default/jetty','');
}
