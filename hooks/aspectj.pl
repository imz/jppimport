#!/usr/bin/perl -w

$spechook = sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->subst(qr'BuildRequires:\s*eclipse-platform','##BuildRequires: eclipse-platform');
    $jpp->get_section('package','')->subst(qr'BuildRequires:\s*eclipse-rcp','##BuildRequires: eclipse-rcp');
    $jpp->get_section('build')->subst(qr'^CLASSPATH=','## --- ');
    $jpp->get_section('build')->subst(qr'^export CLASSPATH=\${CLASSPATH}:\$\(ls ','## --- ');
    $jpp->get_section('build')->subst(qr'^/usr/lib/jvm/java-1.4.2-sun','/lib/jvm/java');
    # blackdown x86_64
    $jpp->get_section('build')->subst(qr'-Xmx256m','-Xmx512m');

    $jpp->disable_package('eclipse-plugins'); 
}
