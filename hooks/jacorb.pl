#!/usr/bin/perl -w

#require 'set_target_14.pl';

# other way is
push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package')->push_body('AutoReq: auto,noshell'."\n");
    $jpp->get_section('prep')->push_body('%__subst \'s,avalon-framework-[0-9\.]\+,avalon-framework-*,\' etc/common-xdoclet.xml'."\n");

#    $jpp->get_section('build')->unshift_body('export ANT_OPTS=-mx80m'."\n");
    $jpp->get_section('build')->unshift_body('export ANT_OPTS=" -Xmx256m "'."\n");

}
