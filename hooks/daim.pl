#!/usr/bin/perl -w

require 'add_missingok_config.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    # jython scripts
    $jpp->get_section('package','scripts')->push_body('AutoReq: yes,nopython'."\n");
    &add_missingok_config($jpp, '/etc/%{name}.conf','');
}



__END__
