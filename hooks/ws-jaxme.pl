#!/usr/bin/perl -w

push @PREHOOKS, 
sub {
    my ($spec,) = @_;
    # hack around hsqldb and dual core CPU (ws-jaxme 0.5.2)
    #$spec->get_section('build')->subst_body(qr'ant all javadoc', "ant all\nant javadoc");
};


push @SPECHOOKS, 
sub {
    my ($spec,) = @_;
    $spec->get_section('package','')->unshift_body('BuildRequires: docbook-dtds'."\n");
#    $spec->get_section('package','')->unshift_body('BuildRequires: xmldb-api-sdk'."\n");
#    $spec->get_section('package','')->unshift_body('Requires: xmldb-api-sdk'."\n");
};

__END__
