#!/usr/bin/perl -w

require 'set_fix_repolib_project.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('BuildRequires: mojo-maven2-plugin-jdepend'."\n");
    $jpp->get_section('package','')->unshift_body('BuildRequires: mojo-maven2-plugin-rat'."\n");
}

__END__
