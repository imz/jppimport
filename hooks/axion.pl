#!/usr/bin/perl -w

$spechook = sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('build')->unshift_body_after("javacc \\\n",qr'export CLASSPATH=\$\(build-classpath');
}