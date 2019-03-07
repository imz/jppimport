#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($spec,) = @_;
    $spec->get_section('package','')->push_body('
Obsoletes: hc-httpclient < 4.1.1
Provides: hc-httpclient = %version'."\n");
};

__END__
