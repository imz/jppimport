#!/usr/bin/perl -w

require 'add_missingok_config.pl';

push @SPECHOOKS, sub {
    my ($spec,) = @_;
    # jython scripts
    $spec->get_section('package','scripts')->push_body('AutoReq: yes,nopython'."\n");
    &add_missingok_config($spec, '/etc/%{name}.conf','');
}



__END__
