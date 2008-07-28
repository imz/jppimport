#!/usr/bin/perl -w
#require 'set_fix_eclipse_dep.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->subst(qr'^%define javahl_dir .*','%define javahl_dir %{_javadir}'."\n");
#    $jpp->get_section('prep')->subst(qr'%{_libdir}/svn-javahl/svn-javahl.jar','/usr/share/java/svn-javahl.jar');
#    $jpp->get_section('install')->subst(qr'%{_libdir}/svn-javahl/svn-javahl.jar','/usr/share/java/svn-javahl.jar');
};

