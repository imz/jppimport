#!/usr/bin/perl -w

require 'set_fix_repolib_project.pl';
require 'set_add_fc_osgi_manifest.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('BuildRequires: velocity14'."\n");
}

__END__
