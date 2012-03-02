#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;

    # bouncycastle 1.46 support
    $jpp->get_section('prep')->push_body(q!
sed -i -e s,DEREncodableVector,ASN1EncodableVector,g `grep -rl DEREncodableVector .`
!);

    # gmaven 1.3 support (see patch in spec)
}

__END__
