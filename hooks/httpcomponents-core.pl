#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($spec, $parent) = @_;
    $spec->get_section('package','')->push_body('
Obsoletes: hc-httpcore < 4.1.1
Provides: hc-httpcore = %version'."\n");
};

__END__
