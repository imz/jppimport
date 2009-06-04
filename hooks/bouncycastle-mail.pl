#!/usr/bin/perl -w

#set java 6

push @SPECHOOKS, 

sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('BuildRequires: junit4'."\n");
}
