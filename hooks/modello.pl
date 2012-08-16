#!/usr/bin/perl -w

require 'add_missingok_config.pl';

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    &add_missingok_config($jpp, '/etc/java/%{name}.conf','');
}
__END__
# 1.3
#    $jpp->get_section('package','')->unshift_body('BuildRequires: jaxb_2_1_api'."\n"); #saxpath
