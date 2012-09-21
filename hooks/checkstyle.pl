#!/usr/bin/perl -w

require 'add_missingok_config.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    &add_missingok_config($jpp, '/etc/java/checkstyle.conf','');
    #$jpp->get_section('package','')->unshift_body(q!BuildRequires: !."\n");
}
