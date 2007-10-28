#!/usr/bin/perl -w

$spechook = sub {
    my ($jpp, $alt) = @_;
    # todo: cli rename!
    $jpp->get_section('package','')->unshift_body('BuildRequires: jakarta-commons-cli-1'."\n");
    $jpp->get_section('build')->unshift_body_after("jakarta-commons-cli-1 \\\n",qr'export CLASSPATH=\$\(build-classpath');
}
