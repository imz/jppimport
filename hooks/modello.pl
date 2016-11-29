#!/usr/bin/perl -w

require 'add_missingok_config.pl';
require 'set_skip_usr_bin_run.pl';

push @SPECHOOKS, 
sub {
    my ($spec, $parent) = @_;
    &add_missingok_config($spec, '/etc/java/%{name}.conf','');
}
__END__
