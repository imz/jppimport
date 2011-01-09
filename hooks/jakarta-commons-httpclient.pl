#!/usr/bin/perl -w

require 'set_add_fc_osgi_manifest.pl';
require 'set_manual_no_dereference.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
};

__END__
