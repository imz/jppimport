#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->subst_if(qr'classpathx-mail-monolithic','classpathx-mail', qr'Requires:');
}
