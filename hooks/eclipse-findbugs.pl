#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    # adaptation for jpp findbugs (old 1.3.5)
    $jpp->get_section('package','')->subst(qr'ant-findbugs','',qr'Requires:');
    $jpp->get_section('install')->subst(qr'/ant/ant-findbugs.jar','/findbugs/lib/findbugs-ant.jar');
    $jpp->get_section('install')->subst(qr'findbugs-bcel.jar','/findbugs/lib/bcel5.3.jar');
    $jpp->get_section('install')->subst(qr'findbugs.jar','/findbugs/lib/findbugs.jar');
    $jpp->get_section('install')->subst(qr'jcip-annotations.jar','/findbugs/lib/jcip-annotations.jar');
    $jpp->get_section('install')->subst(qr'jFormatString.jar','/findbugs/lib/jFormatString.jar');
    $jpp->get_section('install')->subst(qr'jaxen.jar','/findbugs/lib/jaxen.jar');
    $jpp->get_section('install')->subst(qr'jsr-305.jar','/findbugs/lib/jsr-305.jar');
    $jpp->get_section('install')->subst(qr'/objectweb-asm/asm-tree.jar','/findbugs/lib/asm-tree.jar');
    $jpp->get_section('install')->subst(qr'/objectweb-asm/asm.jar','/findbugs/lib/asm.jar');
    $jpp->get_section('install')->subst(qr'/objectweb-asm/asm-commons.jar','/findbugs/lib/asm-commons.jar');
};

