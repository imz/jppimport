#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($spec,) = @_;
    # when upgrade is finished
    $spec->get_section('package','')->push_body('Obsoletes: qdox16-poms < 1.1'."\n");
}
