#!/usr/bin/perl -w

require 'set_velocity14.pl';
push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('BuildRequires: excalibur-avalon-framework mojo-maven2-plugin-changes  mojo-maven2-plugin-jxr maven2-default-skin checkstyle-optional maven2-plugin-checkstyle'."\n");
    $jpp->get_section('package','')->unshift_body('%define _without_tests 1'."\n");
    # if w/o hibernate3
    # {
    #$jpp->get_section('package','')->unshift_body('%define _without_hibernate 1'."\n");
    #$jpp->get_section('build')->unshift_body_after('ln -sf $(build-classpath checkstyle) .'."\n", qr'^pushd tools');
    # test fails :(
    #$jpp->get_section('build')->subst(qr'build dist','dist-jar javadoc');
    # }
}

