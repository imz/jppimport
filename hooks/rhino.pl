#!/usr/bin/perl -w

require 'set_add_fc_osgi_manifest.pl';
require 'add_missingok_config.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    # for /etc/rhino.conf
    #$jpp->get_section('package','')->unshift_body('AutoReq: yes, noshell'."\n");
    #$jpp->get_section('package','repolib')->unshift_body('AutoReq: yes, noshell'."\n");
    &add_missingok_config($jpp, '/etc/%{name}.conf','');
};


