#!/usr/bin/perl -w

$spechook = sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('build')->unshift_body_after('-Dmaven.test.skip=true \\', qr'^maven');
}
