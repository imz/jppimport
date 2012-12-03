#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->subst_body_if(qr'{_hdf5_version}','{get_version libhdf5-devel}',qr'Requires:');
    $jpp->get_section('package','-n jhdfobj')->subst_body_if(qr'{_hdf5_version}','{get_version libhdf5-devel}',qr'Requires:');
};

__END__
