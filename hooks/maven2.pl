#!/usr/bin/perl -w

require 'set_bootstrap.pl';
require 'set_target_14.pl';

# for no bootstrap: E: Версия >='0:1.0-0.b3.2' для 'maven-scm' не найдена

$spechook = sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->subst(qr'gnu\.regexp','gnu-regexp');
    $jpp->get_section('package','')->subst(qr'BuildRequires: modello-maven-plugin','##BuildRequires: modello-maven-plugin');
    $jpp->get_section('package','')->push_body('BuildRequires: checkstyle-optional jmock'."\n");
    $jpp->get_section('package','')->push_body('BuildRequires: saxon-scripts'."\n");
    $jpp->get_section('package','')->push_body('BuildRequires: maven2-bootstrap-bundle'."\n");
    $jpp->get_section('build')->subst(qr'/%3','/[%%]3');
    $jpp->get_section('build')->subst(qr'%3e','/[%%]3e');

    $jpp->add_patch('maven2-2.0.4-MANTTASKS-44.diff');
    $jpp->get_section('prep')->push_body('
%__subst "s,import org.jmock.cglib.Mock,import org.jmock.Mock," maven2-plugins/maven-release-plugin/src/test/java/org/apache/maven/plugins/release/PrepareReleaseMojoTest.java
');

    # to avoid dependency on maven via /etc/mavenrc
    $jpp->get_section('package','')->push_body('%add_findreq_skiplist /usr/share/maven2/bin/mvn'."\n");
};
