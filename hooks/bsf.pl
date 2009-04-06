#!/usr/bin/perl -w

require 'set_epoch_1.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    # jython :(
    $jpp->get_section('package','',)->push_body('%add_findreq_skiplist /usr/share/bsf-*'."\n");
    #$jpp->get_section('package','demo',)->push_body('AutoReq: yes,nopython'."\n");

    # 5.0 exclude repolib
    $jpp->get_section('files','')->push_body('
%exclude %{_javadir}/repository.jboss.com/*
');

    # 1.7
    # dependent libraries changed :(
    #$jpp->get_section('package','',)->push_body('BuildRequires: jakarta-commons-lang'."\n");
    #$jpp->get_section('package','',)->push_body('Requires: jakarta-commons-lang'."\n");
    #$jpp->get_section('build')->unshift_body_after('ln -sf $(build-classpath commons-lang)'."\n",qr'^pushd lib');
};

