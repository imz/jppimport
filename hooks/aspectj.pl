#!/usr/bin/perl -w

#require 'set_target_14.pl';

push @SPECHOOKS, 
 sub {
    my ($jpp, $alt) = @_;
#    $jpp->get_section('package','')->subst_if(qr'1:3.1','0:3.1', qr'Requires:\s*eclipse');
#   $jpp->get_section('package','eclipse-plugins')->subst_if(qr'1:3.1','0:3.1', qr'Requires:\s*eclipse');
#    $jpp->get_section('build')->subst(qr'^/usr/lib/jvm/java-1.4.2-sun','/lib/jvm/java');
    # blackdown x86_64
    $jpp->get_section('build')->subst(qr'-Xmx384m','-Xmx1024m');

#    $jpp->disable_package('eclipse-plugins'); 
}
