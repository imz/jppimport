#!/usr/bin/perl -w

require 'set_fix_repolib_project.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('BuildRequires: mojo-maven2-plugin-jdepend mojo-maven2-plugin-rat'."\n");
    $jpp->get_section('package','')->unshift_body('BuildRequires: velocity14'."\n");
}

__END__
