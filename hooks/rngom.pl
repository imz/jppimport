#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->add_patch('rngom-20061207-alt-javadoc.patch',STRIP=>0);
}
