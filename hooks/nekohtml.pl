#!/usr/bin/perl -w

require 'set_skip_usr_bin_run.pl';
require 'add_missingok_config.pl';

push @SPECHOOKS, 
sub {
    my ($spec,) = @_;
# bugfix; to be commited in bugzilla
    $spec->get_section('files','')->subst_body(qr'^\%doc ','%doc --no-dereference ');
    &add_missingok_config($spec, '/etc/java/%{name}.conf','');
}
