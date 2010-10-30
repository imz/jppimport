#!/usr/bin/perl -w

push @SPECHOOKS, 
 sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body("BuildRequires: maven-scm\n");

    # maven 2.0.8 support
    $jpp->get_section('prep')->unshift_body_after('# maven 2.0.8 support 
mkdir -p .m2/repository/swt/swt-win32/3.0m8
ln -s %{_libdir}/java/swt.jar .m2/repository/swt/swt-win32/3.0m8/swt-win32-3.0m8.jar
',qr'/java/swt.jar .m2/repository/swt/swt-win32.jar');

    # todo fedora deps transl; felix does not seem to work, but fedora's maven-plugin-bundle
    # is doing just fine.
    #$jpp->get_section('package','')->subst_if(qr'maven-plugin-bundle','felix-maven2',qr'Requires');
};

