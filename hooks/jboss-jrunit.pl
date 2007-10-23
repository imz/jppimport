#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('build','')->subst('ant distribution web-app javadocs run-tests', 'ant distribution web-app javadocs');
}
