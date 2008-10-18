#!/usr/bin/perl -w

# 1.7 hacks ; may deprecate at 5.0
require 'set_target_14.pl';

push @SPECHOOKS, 
 sub {
    my ($jpp, $alt) = @_;

    $jpp->get_section('package','')->subst(qr'servletapi5','tomcat5-servlet-2.4-api');

};

1;
