#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->add_patch('portals-pluto-1.0.1-alt-deploy-project-xml.patch', STRIP=>1);
}
