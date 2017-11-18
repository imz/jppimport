#!/usr/bin/perl -w

push @SPECHOOKS, \&set_maven_notests;

sub set_maven_notests {
    my ($spec, $parent) = @_;
    $spec->get_section('build')->map_body(
	sub {
	    s/^\s*\%mvn_build((?:\s*-\S)*)(\s*$)/%mvn_build$1 -- -Dmaven.test.skip.exec=true$2/ or
	    s/^\s*\%mvn_build(.*--)/%mvn_build$1 -Dmaven.test.skip.exec=true /;
	});
};
