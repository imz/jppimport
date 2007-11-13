#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('BuildRequires: dtdparser objectweb-deploysched mx4j gvf'."\n");
    $jpp->get_section('prep')->subst(qr'build-classpath owdeploysched/ow_deployment_scheduling','build-classpath objectweb-deploysched/ow_deployment_scheduling');
    $jpp->get_section('prep')->subst(qr'build-classpath owanttask','build-classpath objectweb-anttask');
    #$jpp->get_section('prep')->subst(qr'build-classpath jmxri','build-classpath mx4j/mx4j-rjmx');?
    $jpp->get_section('prep')->subst(qr'build-classpath jmxri','build-classpath mx4j/mx4j');
    $jpp->get_section('prep')->subst(qr'build-classpath jmxtools','build-classpath mx4j/mx4j-tools');
}
