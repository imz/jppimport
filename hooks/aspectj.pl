#!/usr/bin/perl -w

require 'add_missingok_config.pl';

push @SPECHOOKS, 
 sub {
    my ($jpp, $alt) = @_;
    &add_missingok_config($jpp, '/etc/java/aspectj.conf','');
    $jpp->get_section('build')->subst(qr'-Xmx384','-Xmx1024');
    $jpp->get_section('files','eclipse-plugins')->push_body(q'%_datadir/eclipse/plugins/org.aspect*
#/etc/java/aspectj.conf
'); 
}
