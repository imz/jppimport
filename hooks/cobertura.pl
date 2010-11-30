#!/usr/bin/perl -w

require 'add_missingok_config.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    &add_missingok_config($jpp,'/etc/cobertura-check.conf');
    &add_missingok_config($jpp,'/etc/cobertura-instrument.conf');
    &add_missingok_config($jpp,'/etc/cobertura-merge.conf');
    &add_missingok_config($jpp,'/etc/cobertura-report.conf');
};

1;
__END__
