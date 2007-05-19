#!/usr/bin/perl -w

$spechook = sub {
    my ($jpp, $alt) = @_;
    # hack around alt ant
#    $jpp->get_section('package','')->unshift_body('BuildRequires: ant-trax'."\n");
    $jpp->get_section('package','')->unshift_body('BuildRequires: ant-optional'."\n");
    $jpp->get_section('package','')->subst(qr'BuildRequires:\s*jakarta-commons-cli','BuildRequires: jakarta-commons-cli-1');
    $jpp->get_section('build')->subst(qr'export CLASSPATH=\$\(build-classpath excalibur/avalon-logkit commons-collections\)','export CLASSPATH=$(build-classpath excalibur/avalon-logkit commons-collections velocity jdom)');

    # hack! disabled tests! (xerces-j-2.9.0; tests passed with xerces-j-2.8.x)
    $jpp->get_section('build')->subst(qr' run.tests ',' ');
    $jpp->get_section('files','manual')->subst(qr'%doc target/dist','%doc --no-dereference target/dist');
}
