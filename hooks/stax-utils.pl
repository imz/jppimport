#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->add_patch('stax-utils-0.0-javadoc-exclude.patch',STRIP=>1);
};

1;
