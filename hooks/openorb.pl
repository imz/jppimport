#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('BuildRequires: jakarta-commons-cli'."\n");
    $jpp->get_section('build')->unshift_body_after("commons-cli \\\n",qr'export CLASSPATH=\$\(build-classpath');
}
