#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    # todo: cli rename!
    $jpp->get_section('package','')->unshift_body('BuildRequires: apache-jdo-1.1-impl'."\n");
}
