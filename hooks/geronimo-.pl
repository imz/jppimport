#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->push_body('
');

    $jpp->get_section('files','')->push_body(q!
!."\n");

    $jpp->get_section('install')->push_body(q!
!."\n");
};

__END__
