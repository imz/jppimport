#!/usr/bin/perl -w

require 'set_without_maven.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    # maven-shared-plugin-testing-harness require maven2 and conflicts w/maven-bootstrap
    #$jpp->get_section('package')->subst_if(qr'BuildRequires: ','#BuildRequires: ', qr'maven-shared-plugin-testing-harness');
    # done manually:
#Source33:     plugin-testing-harness-1.2.jar
#export CLASSPATH=$CLASSPATH:%{SOURCE33}
    # bug to report in jpp5: when _without_maven
    $jpp->get_section('build')->subst(qr'plexus/classworlds', 'plexus/classworlds classworlds');
}
