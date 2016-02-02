#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->push_body('AutoReqProv: yes,noosgi'."\n");
    $jpp->get_section('package','')->push_body('Obsoletes: ivy < 2'."\n");
};

__END__
