#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->push_body('
Obsoletes: jformatstring <= 0:0-alt1_0.3.20081016svnjpp6
Conflicts: jformatstring <= 0:0-alt1_0.3.20081016svnjpp6
'."\n");
};

__END__
