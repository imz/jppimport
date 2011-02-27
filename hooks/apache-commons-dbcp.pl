#!/usr/bin/perl -w

require 'set_apache_obsoletes_epoch1.pl';
require 'set_fix_apache_jakarta_symlink.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;

}

__END__
