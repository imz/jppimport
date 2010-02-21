#!/usr/bin/perl -w

require 'add_missingok_config.pl';
require 'set_eclipse_core_plugins.pl';

push @SPECHOOKS, 
 sub {
    my ($jpp, $alt) = @_;
    &add_missingok_config($jpp, '/etc/java/aspectj.conf','');
    $jpp->get_section('package','')->unshift_body('BuildRequires: ant-jakarta-regexp'."\n");
    $jpp->get_section('build')->subst(qr'-Xmx384','-Xmx1024');
    $jpp->get_section('files','eclipse-plugins')->push_body(q'%_datadir/eclipse/plugins/org.aspect*
#/etc/java/aspectj.conf
'); 
}
