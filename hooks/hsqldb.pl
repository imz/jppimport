#!/usr/bin/perl -w

$spechook = sub {
    my ($jpp, $alt) = @_;
    $jpp->add_patch('hsqldb-1.8.0.7-alt-init.patch');
};
