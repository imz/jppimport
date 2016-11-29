#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($spec, $parent) = @_;
    foreach my $sec ($spec->get_sections()) {
	next if $sec->get_type ne 'package';
	$sec->map_body(
	sub {
		s/\s*[>=].*// if /^Requires:.*0:\%{.*-%{release}/;
		}
	);
    }
}
