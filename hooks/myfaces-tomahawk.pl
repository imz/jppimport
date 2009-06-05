#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->add_patch('myfaces-tomahawk-1.1.6-alt-bcel52.patch',STRIP=>1);
};
