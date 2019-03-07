#!/usr/bin/perl -w

require 'set_skip_usr_bin_run.pl';
require 'add_missingok_config.pl';

push @SPECHOOKS, 
sub {
    my ($spec,) = @_;
    # jpp5 bug to report
#unmets:
#javahelp2#0:2.0.05-alt1_1jpp5   /etc/jhindexer.conf
#javahelp2#0:2.0.05-alt1_1jpp5   /etc/jhsearch.conf
#javahelp2-demo#0:2.0.05-alt1_1jpp5 /home/pelegri/netscape02/netscape/netscape
#javahelp2-demo#0:2.0.05-alt1_1jpp5 /usr/local/java/hjb1.1/solaris/bin/hotjava
    $spec->disable_package('demo');
    &add_missingok_config($spec,'/etc/jhindexer.conf');
    &add_missingok_config($spec,'/etc/jhsearch.conf');
}
