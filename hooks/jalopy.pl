#!/usr/bin/perl -w

# TODO:
#require 'set_target_13.pl';
require 'set_manual_no_dereference.pl';

# other way is
push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    # jpackage 5.0 compat
#    $jpp->get_section('package','')->subst_if(qr'docbook-xsl-java-saxon', 'docbook-xsl-saxon', qr'BuildRequires:');

    $jpp->get_section('package','')->unshift_body('BuildRequires: docbook-style-xsl docbook-dtds'."\n");
    # xsl fix
    $jpp->get_section('prep')->subst(qr'/sgml/docbook/xsl-stylesheets', '/xml/docbook/xsl-stylesheets');
    $jpp->get_section('build')->subst(qr'/sgml/docbook/xml-dtd-4.2\*/', '/xml/docbook/dtd/4.2*/');
# without xml fix
#    $jpp->disable_package('manual');
#    $jpp->get_section('build')->subst(qr'build-docu', '');
#    $jpp->get_section('install')->subst_if(qr'^', '#', qr!cp -pr tmp~/docs/api!);
#    $jpp->get_section('install')->subst_if(qr'^', '#', qr!tmp~/docs/manual!);
#    $jpp->disable_package('javadoc');

     
    #$jpp->get_section('build')->unshift_body('export ANT_OPTS="-Xmx256m"'."\n");
    $jpp->get_section('package','')->unshift_body('BuildRequires: ant-trax'."\n");
    $jpp->get_section('build')->subst('^com.icl.saxon.TransformerFactoryImpl"', 'com.icl.saxon.TransformerFactoryImpl -Xmx256m"');
    # eclipse 3.3.x :(
    $jpp->get_section('build')->subst(qr'3\.1\.\*', '3.3.*');
    $jpp->get_section('build')->subst(qr'build-dist-eclipse', '');
    $jpp->get_section('build')->subst(qr'^CLASSPATH=', '#CLASSPATH=');
    $jpp->get_section('package','')->subst(qr'BuildRequires: eclipse-platform', '#BuildRequires: eclipse-platform');
    $jpp->get_section('install')->subst_if(qr'^', '#', qr'eclipsejalodir');
    $jpp->get_section('install')->subst_if(qr'^', '#', qr'jalopy-eclipse');
    $jpp->get_section('install')->subst_if(qr'^', '#', qr'eclipse\*');

    $jpp->disable_package('eclipse');


    # one pixmap is 16x16
    $jpp->get_section('install')->push_body(q'
mkdir -p $RPM_BUILD_ROOT/%_liconsdir
mkdir -p $RPM_BUILD_ROOT/%_miconsdir
mkdir -p $RPM_BUILD_ROOT/%_niconsdir
ln -s $(relative $RPM_BUILD_ROOT/usr/share/pixmaps/%{name}-settings.png $RPM_BUILD_ROOT/%_niconsdir/) $RPM_BUILD_ROOT/%_niconsdir/
ln -s $(relative $RPM_BUILD_ROOT/usr/share/pixmaps/%{name}-settings.png $RPM_BUILD_ROOT/%_liconsdir/) $RPM_BUILD_ROOT/%_liconsdir/
ln -s $(relative $RPM_BUILD_ROOT/usr/share/pixmaps/%{name}-settings.png $RPM_BUILD_ROOT/%_miconsdir/) $RPM_BUILD_ROOT/%_miconsdir/
');

    $jpp->get_section('files')->push_body(q'
%_liconsdir/*
%_miconsdir/*
%_niconsdir/*
');


}
