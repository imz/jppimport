#!/usr/bin/perl -w

push @SPECHOOKS, 

sub  {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->subst_if(qr'maven-plugin-javadoc', 'sf-maven-plugins-javadoc', qr'BuildRequires:');
    $jpp->get_section('package','')->subst_if(qr'maven-plugin-junit-report', 'maven-plugins-base', qr'BuildRequires:');
    $jpp->get_section('build')->unshift_body(q!export MAVEN_OPTS="-Xmx512m"
!);
}
