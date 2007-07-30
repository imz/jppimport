#!/usr/bin/perl -w

$spechook = sub {
    my ($jpp, $alt) = @_;

    $jpp->get_section('package','')->subst(qr'servletapi5','tomcat5-servlet-2.4-api');

};

1;
