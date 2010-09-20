#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->push_body('AutoReqProv: yes,noosgi'."\n");
};

__END__
