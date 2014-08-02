#!/usr/bin/perl -w

require 'set_osgi.pl';
require 'add_missingok_config.pl';
require 'set_skip_usr_bin_run.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    # for /etc/rhino.conf
    #$jpp->get_section('package','')->unshift_body('AutoReq: yes, noshell'."\n");
    #$jpp->get_section('package','repolib')->unshift_body('AutoReq: yes, noshell'."\n");
    &add_missingok_config($jpp, '/etc/%{name}.conf','');
};


