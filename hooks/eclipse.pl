#!/usr/bin/perl -w

$spechook = sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->subst(qr'mozilla-nspr-devel', 'libnspr-devel');

   $jpp->get_section('package','')->unshift_body('BuildRequires: ant-bcel ant-jakarta-oro ant-jakarta-regexp ant-log4j ant-bsf ant-xml-resolver'."\n");
   $jpp->get_section('package','')->unshift_body('BuildRequires: zip'."\n");


    $jpp->get_section('package','ecj')->subst(qr'Obsoletes:	ecj', '#Obsoletes:	ecj');
    $jpp->get_section('package','ecj')->subst(qr'Provides:	ecj', '#Provides:	ecj');

    $jpp->get_section('build')->subst(qr'%\{SOURCE22','%%{SOURCE22');
    $jpp->get_section('build')->subst(qr'%\{SOURCE23','%%{SOURCE23');
    $jpp->get_section('install')->subst(qr'%\{SOURCE23','%%{SOURCE23');
    $jpp->get_section('files', '-n %{libname}-gtk2 -f %{libname}-gtk2.install')->subst(qr'%%\{swt_bundle_id}','%%{swt_bundle_id}');
    $jpp->get_section('build')->subst(qr'ln -sf %{_datadir}/lucene/lucene-demos-1.4.3.jar plugins/org.apache.lucene/parser.jar',
'ln -sf %{_javadir}/lucene-demos.jar plugins/org.apache.lucene/parser.jar');

#    $jpp->get_section('package','')->subst(qr'BuildRequires:\s*ant-apache-bcel','BuildRequires: ant-bcel');
#    $jpp->get_section('package','')->subst(qr'BuildRequires:\s*ant-apache-oro','BuildRequires: ant-jakarta-oro');
#    $jpp->get_section('package','')->subst(qr'BuildRequires:\s*ant-apache-regexp','BuildRequires: ant-jakarta-regexp');
#    $jpp->get_section('package','')->subst(qr'BuildRequires:\s*ant-apache-log4j','BuildRequires: ant-log4j');
#    $jpp->get_section('package','')->subst(qr'BuildRequires:\s*ant-apache-bcel','BuildRequires: ant-bcel');
#    $jpp->get_section('package','')->subst(qr'BuildRequires:\s*ant-apache-resolver','BuildRequires: ant-xml-resolver');
}
