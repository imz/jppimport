#!/usr/bin/perl -w

require 'set_fix_jakarta_commons_cli.pl';
require 'set_bootstrap.pl';
#require 'set_target_14.pl';

$spechook = sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->subst(qr'gnu\.regexp','gnu-regexp');
    $jpp->get_section('package','')->push_body('BuildRequires: saxon-scripts'."\n");
    $jpp->get_section('build')->subst(qr'/%3','/[%%]3');
    $jpp->get_section('build')->subst(qr'%3e','/[%%]3e');
};

