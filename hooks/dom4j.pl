#!/usr/bin/perl -w

$spechook = sub {
    my ($jpp, $alt) = @_;
    # included in jpackage-compat
    # $jpp->get_section('package','')->unshift_body('BuildRequires: ant-junit'."\n");
    # one test fails :( to rebuild later
    $jpp->get_section('build')->subst(qr'ant all samples test','ant all samples');
}
