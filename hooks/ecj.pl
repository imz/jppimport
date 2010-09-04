#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('Obsoletes: ecj-standalone <= 3.4.2-alt4_0jpp6'."\n");

    # ecj should not have osgi dependencies.
    $jpp->get_section('package','')->push_body('
AutoReq: yes, noosgi
AutoProv: yes, noosgi
');

    # SEE https://bugzilla.altlinux.org/23902
    $jpp->get_section('package','')->subst_if(qr'^Requires\(post','#Requires(post',qr'java-gcj-compat');
    # not nesessary
    $jpp->get_section('package','')->subst_if(qr'^BuildRequires: java-gcj-compat',"#BuildRequires: java-gcj-compat\nBuildRequires: fastjar");


    # hack -- exclude pom as it breaks builds due 
    # to strange deps on eclipse (moreover, eclipse does not have poms)
    $jpp->get_section('files','')->exclude('maven');
};
