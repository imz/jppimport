#!/usr/bin/perl -w

push @PREHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    # hack around hsqldb and dual core CPU (ws-jaxme 0.5.2)
    #$jpp->get_section('build')->subst(qr'ant all javadoc', "ant all\nant javadoc");
};


push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('BuildRequires: docbook-xml docbook-dtds'."\n");
    $jpp->get_section('package','')->unshift_body('BuildRequires: xmldb-api-sdk'."\n");
    $jpp->get_section('package','')->unshift_body('Requires: xmldb-api-sdk'."\n");
};

__END__
