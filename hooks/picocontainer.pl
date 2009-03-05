#!/usr/bin/perl -w

require 'set_without_maven.pl';

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('BuildRequires: mojo-maven2-plugin-cobertura maven2-plugin-project-info-reports maven-scm maven2-default-skin cobertura maven2-plugin-source maven2-plugin-release maven2-plugin-dependency'."\n");
    $jpp->get_section('package','')->unshift_body('BuildRequires: excalibur excalibur-avalon-framework avalon-framework'."\n");
    # i am bored to mention them all :(
    $jpp->get_section('package','')->unshift_body('BuildRequires: maven2-plugins'."\n");

    $jpp->get_section('build')->subst(qr'build-classpath proxytoys prefuse jmock xstream cglib-nodep xpp3-minimal','build-classpath proxytoys prefuse jmock xstream cglib-nodep xpp3-minimal commons-logging');

}
