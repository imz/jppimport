#!/usr/bin/perl -w

require 'add_missingok_config.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('build')->unshift_body(q!export LANG=en_US.ISO8859-1!."\n");
    &add_missingok_config($jpp,'/etc/cobertura-check.conf');
    &add_missingok_config($jpp,'/etc/cobertura-instrument.conf');
    &add_missingok_config($jpp,'/etc/cobertura-merge.conf');
    &add_missingok_config($jpp,'/etc/cobertura-report.conf');
};

1;
__END__
