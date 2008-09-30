#!/usr/bin/perl -w

# or let it be java4?
require 'set_with_java5.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body("BuildRequires: maven-surefire-plugin\n");
};

