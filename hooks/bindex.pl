#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    # jpp/devel
    $jpp->get_section('package','')->unshift_body('BuildRequires: felix-osgi-obr'."\n");
    # fc16
#    $jpp->get_section('package','')->unshift_body('BuildRequires: kxml'."\n");
};

__END__

        3) javax.xml.bind:jaxb-api:jar:1.0.6
        4) javax.xml.stream:stax-api:jar:1.0-2
