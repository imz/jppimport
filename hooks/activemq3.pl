#!/usr/bin/perl -w

#require 'set_bootstrap.pl';
require 'set_target_14.pl';

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
#    $jpp->get_section('package','')->unshift_body('BuildRequires: geronimo-specs-poms'."\n");
    $jpp->get_section('prep')->unshift_body(q!perl -npe 's,geronimo/spec-(.+)\.jar,geronimo-$1-api.jar,' -i %{SOURCE4}!."\n");
    $jpp->get_section('prep')->push_body(q!# timeout
rm modules/core/src/test/org/activemq/FragmentPersistentQueueTest.java
rm modules/core/src/test/org/activemq/Fragment*Test.java
!);
    $jpp->get_section('build')->unshift_body(q!export MAVEN_OPTS="-Xmx512M"!."\n");
}
