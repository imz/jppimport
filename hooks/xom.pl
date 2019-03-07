#!/usr/bin/perl -w

require 'set_target_15.pl';

push @SPECHOOKS, sub {
    my ($spec,) = @_;
    $spec->get_section('package','')->unshift_body('BuildRequires: dom4j'."\n");
}
