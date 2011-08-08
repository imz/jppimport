#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->add_patch('wadi-2.0-alt-fix-project.xml.patch',STRIP=>1);
}
