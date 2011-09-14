#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;

    # bouncycastle 1.46 support
    $jpp->get_section('prep')->push_body(q!
sed -i -e s,DEREncodableVector,ASN1EncodableVector,g `grep -rl DEREncodableVector .`
!);

    # gmaven 1.3 support (does not help)
#    $jpp->get_section('prep')->push_body(q!
#sed -i -e s,org.codehaus.groovy.maven,org.codehaus.gmaven, clients/java/pom.xml
#sed -i -e s,gmaven-runtime-default,gmaven-runtime-1.5, clients/java/pom.xml
#!);
}

__END__
