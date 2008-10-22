#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
#    $jpp->get_section('package','')->subst_if(qr'classpathx-mail-monolithic','classpathx-mail', qr'Requires:');
    $jpp->get_section('package','')->subst_if(qr'jaxws_2_0_api','jaxws_2_1_api', qr'Requires:');
    # until jetty6
    $jpp->get_section('package','')->subst_if(qr'jetty6','jetty6-core', qr'Requires:');
}
