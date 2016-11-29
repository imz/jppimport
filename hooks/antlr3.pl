#!/usr/bin/perl -w

require 'set_skip_usr_bin_run.pl';
push @SPECHOOKS, 
sub {
    my ($spec, $parent) = @_;
    foreach my $sec ($spec->get_sections()) {
	next if $sec->get_type ne 'package';
	next if !$sec->get_raw_package;
	$sec->exclude_body('^Release:');
    }
};

__END__
