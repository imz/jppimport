#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('install')->push_body(q!# compat for old groovy 1 jpp5
%add_to_maven_depmap com.tonicsystems jarjar %{version} JPP %{name}
!);
}
