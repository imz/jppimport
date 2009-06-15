#!/usr/bin/perl -w

require 'set_exclude_repolib.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    if (! $jpp->get_section('package','')->match(qr'jakarta-commons-codec-addosgimanifest.patch')) {
	# it is import from jpackage; we need to add OSGi manifest
	# OSGi Bundle-Version: 1.3.0.v20080530-1600
	$jpp->add_patch('jakarta-commons-codec-addosgimanifest.patch');
    }
};

__END__
