#!/usr/bin/perl -w

$spechook = sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('BuildRequires: maven-scm mojo-maven2-plugin-jdepend mojo-maven2-plugin-jxr'."\n");
}
