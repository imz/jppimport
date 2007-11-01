#!/usr/bin/perl -w

$spechook = sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('BuildRequires: jaf bsf'."\n");
$jpp->get_section('build')->unshift_body_after('ln -sf $(build-classpath bsf)'."\n",qr'pushd lib');
$jpp->get_section('build')->unshift_body_after('ln -sf $(build-classpath jaf)'."\n",qr'pushd lib');
}
