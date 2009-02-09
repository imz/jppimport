#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('BuildRequires: java-devel = 1.5.0
');
    $jpp->get_section('prep')->push_body(q@
subst 's!,.\?compile_jdbc4!!' java/engine/org/apache/derby/jdbc/build.xml
subst 's!,.\?compile_jdbc4!!' java/engine/org/apache/derby/impl/jdbc/build.xml
subst 's!,.\?compile_jdbc4!!' java/engine/org/apache/derby/iapi/jdbc/build.xml
subst 's!,.\?compile_jdbc4!!' java/client/build.xml
@);
    $jpp->get_section('build')->subst(qr'^ant \\','ant -Dbuild.sysclasspath=first \\');
};

