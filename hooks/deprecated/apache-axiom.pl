#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->add_patch('apache-axiom-1.0-alt-fix-project-xml.patch', STRIP=>0);
}
