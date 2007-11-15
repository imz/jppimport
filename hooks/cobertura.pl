#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->add_patch('cobertura-1.9-javadoc-exclude.patch');
};

1;
