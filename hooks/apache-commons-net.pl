#!/usr/bin/perl -w

require 'set_fix_repolib_project.pl';
#require 'set_add_fc_osgi_manifest.pl';
require 'set_osgi.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('BuildRequires: mojo-maven2-plugin-jdepend mojo-maven2-plugin-rat'."\n");
    # hack till eclipse-rse build from fc14
    $jpp->get_section('package','')->unshift_body('Provides: osgi(org.apache.commons.net) = 2.0.0'."\n");
}

__END__
