#!/usr/bin/perl -w

require 'set_excalibur_pom.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body(q!BuildRequires: mojo-maven2-plugin-cobertura maven2-default-skin jetty6-core jetty6-jsp-2.0-api jetty6-servlet-2.5-api slf4j
!);
    # bug to report
    $jpp->get_section('install')->subst(qr'ln -sf %{_javadir}/nanocontainer-booter.jar','ln -sf %{_javadir}/nanocontainer/booter.jar');
}

