#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    # jpp 1.7 break by 5.0 (to report)
    $jpp->add_patch('carol-cmi-1.2.7-alt-jgroups-2.4.patch');
}
