#!/usr/bin/perl -w

require 'remove_java_devel.pl';

$spechook = sub {
    my ($jpp, $alt) = @_;
    &remove_java_devel($jpp, $alt);
    $jpp->get_section('package','')->unshift_body('%define _bootstrap 1'."\n");
}
