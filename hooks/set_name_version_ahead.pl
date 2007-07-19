#!/usr/bin/perl -w

$spechook = sub {
    my ($jpp, $alt) = @_;
    # hack; Source is before name-version
    $jpp->get_section('package','')->unshift_body('%define name '.$jpp->get_section('package','')->get_tag('Name')."\n");
    $jpp->get_section('package','')->unshift_body('%define version '.$jpp->get_section('package','')->get_tag('Version')."\n");
}
