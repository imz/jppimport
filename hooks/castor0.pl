#!/usr/bin/perl -w

require 'set_without_tests.pl';
require 'add_missingok_config.pl';

push @SPECHOOKS, 
 sub {
    my ($jpp, $alt) = @_;
    &add_missingok_config($jpp, '/etc/java/%{name}.conf');
}
