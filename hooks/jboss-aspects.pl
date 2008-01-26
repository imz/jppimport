#!/usr/bin/perl -w

require 'set_jboss_ant17.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    # TODO: report a bug (broken symlinks)
    $jpp->get_section('install')->subst(qr'jboss-aop/jboss-aspect','jboss-aspects/jboss-aspect');

}

