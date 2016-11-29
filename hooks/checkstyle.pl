#!/usr/bin/perl -w

require 'add_missingok_config.pl';
require 'set_skip_usr_bin_run.pl';

push @SPECHOOKS, sub {
    my ($spec, $parent) = @_;
    &add_missingok_config($spec, '/etc/java/checkstyle.conf','');
    #$spec->get_section('package','')->unshift_body(q!BuildRequires: !."\n");
}
