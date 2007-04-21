#!/usr/bin/perl -w

$spechook = sub {
    my ($jpp, $alt) = @_;
    # hack; Source is before name-version
    $jpp->get_section('package','')->unshift_body('%define name geronimo-specs'."\n");
    $jpp->get_section('package','')->unshift_body('%define version 1.1'."\n");
}
