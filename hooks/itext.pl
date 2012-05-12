#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','core')->push_body('Obsoletes: itext2 <= 2.1.7-alt1_9jpp6'."\n");
};

__END__
