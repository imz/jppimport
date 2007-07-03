#!/usr/bin/perl -w

$spechook = sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package')->subst(qr'BuildRequires: jboss4-common','BuildRequires: jboss');
    $jpp->get_section('package')->subst(qr'BuildRequires: jboss4-jmx','##BuildRequires: jboss4-jmx');
    $jpp->get_section('package')->subst(qr'BuildRequires: jboss4-system','##BuildRequires: jboss4-system');
    $jpp->get_section('build')->subst(qr'$(build-classpath jboss4/jboss-common):','/usr/share/jboss/lib/jboss-common.jar');
    $jpp->get_section('build')->subst(qr'$(build-classpath jboss4/jboss-jmx):','/usr/share/jboss/lib/jboss-jmx.jar');
    $jpp->get_section('build')->subst(qr'$(build-classpath jboss4/jboss-system)','/usr/share/jboss/lib/jboss-system.jar');
}
