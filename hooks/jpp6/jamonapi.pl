#!/usr/bin/perl -w

push @SPECHOOKS, 
 sub {
    my ($jpp, $alt) = @_;
    # bug to report? (jpp5, but old jetty6-core)
    $jpp->get_section('prep')->subst(qr'jetty6/core/jetty6','jetty6/jetty6');
};

