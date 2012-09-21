#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
#    $jpp->get_section('package','')->push_body('Obsoletes: aspectj < 1.5.5'."\n");
};

__END__
