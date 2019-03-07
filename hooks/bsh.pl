#!/usr/bin/perl -w
require 'add_missingok_config.pl';

push @SPECHOOKS, sub {
    my ($spec,) = @_;
    &add_missingok_config($spec, '/etc/java/%{name}.conf');
};

__END__
