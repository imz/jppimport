#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($spec,) = @_;
    $spec->get_section('package','')->push_body('
Obsoletes: jformatstring <= 0:0-alt1_0.3.20081016svnjpp6
Conflicts: jformatstring <= 0:0-alt1_0.3.20081016svnjpp6
'."\n");
    $spec->get_section('pretrans','javadoc')->delete;
};

__END__
