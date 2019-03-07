#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($spec,) = @_;
    $spec->get_section('package','core')->push_body('Obsoletes: itext2 <= 2.1.7-alt1_9jpp6'."\n");
};

__END__
