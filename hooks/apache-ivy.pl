#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($spec, $parent) = @_;
    $spec->get_section('package','')->push_body('AutoReqProv: yes,noosgi'."\n");
    $spec->get_section('package','')->push_body('Obsoletes: ivy < 2'."\n");
};

__END__
