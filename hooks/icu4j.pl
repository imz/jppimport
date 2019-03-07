#!/usr/bin/perl -w

require 'set_osgi.pl';
require 'set_add_java_bin.pl';

push @SPECHOOKS, sub {
    my ($spec,) = @_;
};
__END__
