#!/usr/bin/perl -w

require 'set_skip_usr_bin_run.pl';
require 'add_missingok_config.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    &add_missingok_config($jpp, '/etc/mvel.conf','');
}
