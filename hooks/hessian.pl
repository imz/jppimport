#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->add_patch('hessian-3.0.8-alt-java5fix.patch');
};

1;
