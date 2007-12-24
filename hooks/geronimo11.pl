#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('BuildRequires: tomcat5-webapps'."\n");
    $jpp->get_section('package','')->unshift_body('%define _bootstrap1 1'."\n");
    $jpp->get_section('package','')->unshift_body('%define _with_bootstrap1 1'."\n");

    $jpp->get_section('build')->unshift_body('export MAVEN_OPTS="-Xmx256m"'."\n");
#-Dmaven.test.skip=true
# bug to report: 
# Пакет не существует: %post server-base
    $jpp->disable_package('server-base');
};

