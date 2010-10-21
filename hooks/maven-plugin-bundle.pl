#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    # TODO: fedora13 map
    #felix-osgi-core -> felix
    #felix-osgi-obr -> felix
    # kxml -> kxml2
    $jpp->get_section('package','')->unshift_body('BuildRequires: maven-release'."\n");
    $jpp->get_section('package','')->subst_if(qr'felix-osgi-obr','felix',qr'Requires');
    $jpp->get_section('package','')->subst_if(qr'kxml','kxml2',qr'Requires');
};

