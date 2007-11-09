#!/usr/bin/perl -w
require 'add_missingok_config.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('build')->unshift_body_after('ln -sf $(build-classpath bsf)'."\n",qr'pushd lib');
    &add_missingok_config($jpp, '/etc/%{name}.conf');
};

