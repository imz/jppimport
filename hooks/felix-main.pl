#!/usr/bin/perl -w
push @SPECHOOKS, 
sub {
    my ($spec,) = @_;
    # hack to avoid conflicts when 2 felixes are installed
    $spec->get_section('package','')->push_body('Obsoletes: felix < 2'."\n");
};

__END__
