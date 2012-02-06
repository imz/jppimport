#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->subst_if(qr'\scommons-jexl',' apache-commons-jexl',qr'Requires:');
};

__END__
