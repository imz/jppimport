#!/usr/bin/perl -w

require 'set_jboss_ant18.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    # /usr/bin/jar :(
    $jpp->get_section('package','')->push_body('%add_findreq_skiplist /usr/share/%name/bin/*'."\n");
    $jpp->get_section('build')->subst(qr'build-classpath buildmagic','build-classpath buildmagic jboss-common-core');
};

