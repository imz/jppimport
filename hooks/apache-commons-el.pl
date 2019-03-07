#!/usr/bin/perl -w

require 'set_osgi.pl';
require 'set_apache_obsoletes_epoch1.pl';

push @SPECHOOKS, sub {
    my ($spec,) = @_;
}

__END__
