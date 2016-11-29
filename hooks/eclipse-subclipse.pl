#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($spec, $parent) = @_;
#    $spec->get_section('build')->unshift_body('# ???
#mkdir `pwd`/orbitDeps
#');
    #$spec->get_section('package','')->subst(qr'^%define javahl_dir .*','%define javahl_dir %{_javadir}'."\n");
#    $spec->get_section('prep')->subst(qr'%{_libdir}/svn-javahl/svn-javahl.jar','/usr/share/java/svn-javahl.jar');
#    $spec->get_section('install')->subst(qr'%{_libdir}/svn-javahl/svn-javahl.jar','/usr/share/java/svn-javahl.jar');
};

