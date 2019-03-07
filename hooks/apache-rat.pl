#!/usr/bin/perl -w

require 'add_missingok_config.pl';
require 'set_skip_usr_bin_run.pl';

push @SPECHOOKS, sub {
    my ($spec,) = @_;
    &add_missingok_config($spec, '/etc/java/apache-rat.conf','core');
}
