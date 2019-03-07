#!/usr/bin/perl -w

push @SPECHOOKS, \&set_epoch_1;

sub set_epoch_1 {
    my ($spec,) = @_;
    $spec->get_section('package','')->set_tag('Epoch',1);
}
