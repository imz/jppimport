#!/usr/bin/perl -w
require 'set_no_fedora_vendor.pl';

push @SPECHOOKS,
sub {
    my ($spec,) = @_;
    $spec->get_section('prep')->push_body(q!sed -i s,/usr/bin/bash,/bin/bash, %SOURCE1!."\n");
};

__END__
