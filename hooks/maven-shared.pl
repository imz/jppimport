#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    foreach my $sec ($jpp->get_sections()) {
	next if $sec->get_type ne 'package';
	$sec->map_body(
	sub {
		s/\s*[>=].*// if /^Requires:.*0:\%{.*-%{release}/;
		}
	);
    }
}
