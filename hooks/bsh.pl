#!/usr/bin/perl -w
require 'add_missingok_config.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    &add_missingok_config($jpp, '/etc/%{name}.conf');
};

__END__
