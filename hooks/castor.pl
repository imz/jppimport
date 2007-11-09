#!/usr/bin/perl -w

require 'add_missingok_config.pl';

$spechook = sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('BuildRequires: jakarta-commons-logging'."\n");
    &add_missingok_config($jpp, '/etc/java/%{name}.conf');
}
