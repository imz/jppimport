#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body(q!BuildRequires: mojo-maven2-plugin-cobertura
!);
}
