#!/usr/bin/perl -w

push @PREHOOKS, 
sub {
    my ($spec, $parent) = @_;
    # hack around hsqldb and dual core CPU (ws-jaxme 0.5.2)
    #$spec->get_section('build')->subst(qr'ant all javadoc', "ant all\nant javadoc");
};


push @SPECHOOKS, 
sub {
    my ($spec, $parent) = @_;
    $spec->get_section('package','')->unshift_body('BuildRequires: docbook-dtds'."\n");
#    $spec->get_section('package','')->unshift_body('BuildRequires: xmldb-api-sdk'."\n");
#    $spec->get_section('package','')->unshift_body('Requires: xmldb-api-sdk'."\n");
};

__END__
