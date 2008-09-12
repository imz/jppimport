#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->add_patch('ht2html-2.0-alt-fix-whrandom.patch');
};

1;
