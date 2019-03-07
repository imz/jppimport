#!/usr/bin/perl -w

push @SPECHOOKS, \&set_maven_ignore_tests;

sub set_maven_ignore_tests {
    my ($spec,) = @_;
    $spec->get_section('build')->map_body(
	sub {
	    s/^\s*\%mvn_build((?:\s*-\S)*)(\s*$)/%mvn_build$1 -- -Dmaven.test.failure.ignore=true$2/ or
	    s/^\s*\%mvn_build(.*--)/%mvn_build$1 -Dmaven.test.failure.ignore=true /;
	});
};
