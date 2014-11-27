#!/usr/bin/perl -w

require 'set_bin_755.pl';

push @SPECHOOKS, 
sub {
    my ($spec, $parent) = @_;
    $spec->get_section('pretrans','-p <lua>')->delete;
};

__END__
