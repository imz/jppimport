#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($spec, $parent) = @_;
    # adaptation for jpp findbugs (old 1.3.5)
    $spec->get_section('package','')->subst_body(qr'ant-findbugs','',qr'Requires:');
    $spec->get_section('install')->subst_body(qr'/ant/ant-findbugs.jar','/findbugs/lib/findbugs-ant.jar');
    $spec->get_section('install')->subst_body(qr'findbugs-bcel.jar','/findbugs/lib/bcel5.3.jar');
    $spec->get_section('install')->subst_body(qr'findbugs.jar','/findbugs/lib/findbugs.jar');
    $spec->get_section('install')->subst_body(qr'jcip-annotations.jar','/findbugs/lib/jcip-annotations.jar');
    $spec->get_section('install')->subst_body(qr'jFormatString.jar','/findbugs/lib/jFormatString.jar');
    $spec->get_section('install')->subst_body(qr'jaxen.jar','/findbugs/lib/jaxen.jar');
    $spec->get_section('install')->subst_body(qr'jsr-305.jar','/findbugs/lib/jsr-305.jar');
    $spec->get_section('install')->subst_body(qr'/objectweb-asm/asm-tree.jar','/findbugs/lib/asm-tree.jar');
    $spec->get_section('install')->subst_body(qr'/objectweb-asm/asm.jar','/findbugs/lib/asm.jar');
    $spec->get_section('install')->subst_body(qr'/objectweb-asm/asm-commons.jar','/findbugs/lib/asm-commons.jar');
};

