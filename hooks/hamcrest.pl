#!/usr/bin/perl -w

require 'set_osgi.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;

    # due to jmock2 which is currently does not build with hamcrest built with java7
    $jpp->get_section('package','')->subst_body_if(qr'jpackage-compat','jpackage-1.6.0-compat',qr'Requires:');

}
__END__
