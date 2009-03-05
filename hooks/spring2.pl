#!/usr/bin/perl -w

require 'windows-thumbnail-database-in-package.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('BuildRequires: avalon-framework'."\n");
};
__END__
