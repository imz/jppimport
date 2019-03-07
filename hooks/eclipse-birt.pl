#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($spec,) = @_;
    $spec->get_section('package','')->unshift_body('BuildRequires: xml-commons-jaxp-1.3-apis'."\n");
    $spec->get_section('prep')->subst_body(qr'xml-commons-apis-ext.jar','xml-commons-jaxp-1.3-apis-ext.jar');
    $spec->get_section('install')->subst_body(qr'xml-commons-apis-ext.jar','xml-commons-jaxp-1.3-apis-ext.jar');

    # different noarches due to .qualifier in version (is replaced by timestamp)
    $spec->get_section('package','')->unshift_body(q!%define rlsdate %(date '+%%Y%%m%%d0000')!."\n");
    # -DjavacSource/Target are mandatory due to defaults in pdebuild (findMaxBREE)
    $spec->get_section('build')->subst_body(qr'pdebuild','pdebuild -a "-DforceContextQualifier=%{rlsdate} -DjavacSource=1.5 -DjavacTarget=1.5"');
};

