#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('BuildRequires: tomcat5-webapps geronimo-javamail-1.3.1-api geronimo-jaf-1.0.2-api'."\n");
    $jpp->get_section('build')->unshift_body('export MAVEN_OPTS="-Xmx256m"'."\n");

    my $bootstrap2=1;
#-Dmaven.test.skip=true
    if ($bootstrap2) {
# bug to report: 
# Пакет не существует at bootstrap1 && 2: %post server-base
	$jpp->disable_package('server-base');
# note: depmap was fixed manually; use the one from successfull bootstrap2 build
# note: maven arguments: added -Dmaven.ignore.versions
	$jpp->get_section('package','')->unshift_body('%define _bootstrap2 1'."\n");
	$jpp->get_section('package','')->unshift_body('%define _with_bootstrap2 1'."\n");
    }
};

