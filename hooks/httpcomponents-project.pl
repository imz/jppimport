#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($spec, $parent) = @_;
    $spec->get_section('package','')->push_body('
Obsoletes: hc-project < 4.1.1-alt1_1jpp6
Provides: hc-project = %version-%release'."\n");
};

__END__
