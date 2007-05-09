#!/usr/bin/perl -w

$spechook = sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->subst(qr'tomcat5-jsp-2.0-api', 'servletapi5');
}
