#!/usr/bin/perl -w

require 'set_osgi.pl';
require 'add_missingok_config.pl';
require 'set_skip_usr_bin_run.pl';

push @SPECHOOKS, sub {
    my ($spec, $parent) = @_;
    # for /etc/rhino.conf
    #$spec->get_section('package','')->unshift_body('AutoReq: yes, noshell'."\n");
    #$spec->get_section('package','repolib')->unshift_body('AutoReq: yes, noshell'."\n");
    &add_missingok_config($spec, '/etc/%{name}.conf','');
};


