#!/usr/bin/perl -w

require 'set_skip_usr_bin_run.pl';
require 'add_missingok_config.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    &add_missingok_config($jpp,'/etc/groovy.conf');
};

1;
__END__
    $jpp->get_section('package','')->subst_body_if(qr'junit','junit4',qr'Requires:');
    $jpp->get_section('build')->subst_body(qr'xstream ant junit ivy','xstream ant junit4 ivy');
