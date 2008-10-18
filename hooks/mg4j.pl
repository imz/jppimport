#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    # jpp5 bug to report? (javadoc deps, but packages are missing
    $jpp->get_section('package','')->unshift_body('BuildRequires: fastutil5 dsiutils colt sg-jal servletapi5 velocity log4j sux4j
BuildRequires: jakarta-commons-configuration jakarta-commons-io jakarta-commons-lang
'."\n");
}
