#!/usr/bin/perl -w

require 'set_without_maven2.pl';

$spechook = sub {
    my ($jpp, $alt) = @_;
    &set_without_maven($jpp, $alt);
    $jpp->get_section('package','')->unshift_body('Requires: jakarta-commons-logging'."\n");
    $jpp->get_section('package','')->unshift_body('BuildRequires: jakarta-commons-logging'."\n");
}
