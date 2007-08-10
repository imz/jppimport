#!/usr/bin/perl -w

push @SPECHOOKS, \&set_add_mx4j_dep;

# todo: chack and fix (jpp bug?)
sub set_add_mx4j_dep {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package')->push_body('
BuildRequires: mx4j
Requires: mx4j
');
}
