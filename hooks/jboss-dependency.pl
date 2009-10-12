#!/usr/bin/perl -w

require 'set_jboss_ant17.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('BuildRequires: jboss-test'."\n");
    $jpp->get_section('prep')->subst('jboss4/jboss-test','jboss/jboss-test');
}
