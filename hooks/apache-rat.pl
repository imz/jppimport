#!/usr/bin/perl -w

require 'add_missingok_config.pl';
require 'set_skip_usr_bin_run.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    &add_missingok_config($jpp, '/etc/java/apache-rat.conf','core');
}
