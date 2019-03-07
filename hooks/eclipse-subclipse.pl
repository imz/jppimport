#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($spec,) = @_;
#    $spec->get_section('build')->unshift_body('# ???
#mkdir `pwd`/orbitDeps
#');
    #$spec->get_section('package','')->subst_body(qr'^%define javahl_dir .*','%define javahl_dir %{_javadir}'."\n");
#    $spec->get_section('prep')->subst_body(qr'%{_libdir}/svn-javahl/svn-javahl.jar','/usr/share/java/svn-javahl.jar');
#    $spec->get_section('install')->subst_body(qr'%{_libdir}/svn-javahl/svn-javahl.jar','/usr/share/java/svn-javahl.jar');
};

