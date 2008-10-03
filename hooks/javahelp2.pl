#!/usr/bin/perl -w

require 'add_missingok_config.pl';

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    # jpp5 bug to report
#unmets:
#javahelp2#0:2.0.05-alt1_1jpp5   /etc/jhindexer.conf
#javahelp2#0:2.0.05-alt1_1jpp5   /etc/jhsearch.conf
#javahelp2-demo#0:2.0.05-alt1_1jpp5 /home/pelegri/netscape02/netscape/netscape
#javahelp2-demo#0:2.0.05-alt1_1jpp5 /usr/local/java/hjb1.1/solaris/bin/hotjava
    $jpp->disable_package('demo');
    &add_missingok_config($jpp,'/etc/jhindexer.conf');
    &add_missingok_config($jpp,'/etc/jhsearch.conf');
}