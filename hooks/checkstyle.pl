#!/usr/bin/perl -w

    #$jpp->get_section('files','manual')->subst(qr'%doc target/dist','%doc --no-dereference target/dist');
require 'set_manual_no_dereference.pl';

$spechook = sub {
    my ($jpp, $alt) = @_;
    # hack around alt ant
#    $jpp->get_section('package','')->unshift_body('BuildRequires: ant-trax'."\n");
    $jpp->get_section('package','')->unshift_body('BuildRequires: ant-optional'."\n");
    $jpp->get_section('package','')->unshift_body('BuildRequires: jakarta-commons-lang'."\n");
    $jpp->get_section('build')->subst(qr'export CLASSPATH=\$\(build-classpath excalibur/avalon-logkit commons-collections\)','export CLASSPATH=$(build-classpath excalibur/avalon-logkit commons-collections velocity jdom jakarta-commons-lang)');

    # hack! disabled tests! (xerces-j-2.9.0; tests passed with xerces-j-2.8.x)
    $jpp->get_section('build')->subst(qr' run.tests ',' ');
}
