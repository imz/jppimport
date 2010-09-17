#!/usr/bin/perl -w

require 'set_jboss_ant18.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('BuildRequires: geronimo-jms-1.1-api jboss-test jboss-common'."\n");
    $jpp->get_section('build')->subst(qr'jboss/jboss-test','jboss/jboss-test jboss-common/jboss-common');
}
