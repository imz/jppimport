#!/usr/bin/perl -w

$spechook = sub {
    my ($jpp, $alt) = @_;
    # todo: cli rename!
    $jpp->get_section('package','')->unshift_body('BuildRequires: wsdl4j'."\n");
#    $jpp->get_section('build')->unshift_body_after("jakarta-commons-cli-1 \\\n",qr'export CLASSPATH=\$\(build-classpath');
}
