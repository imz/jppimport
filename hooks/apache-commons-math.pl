#!/usr/bin/perl -w

require 'set_fix_apache_jakarta_symlink.pl';

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('BuildRequires: mojo-maven2-plugin-jdepend mojo-maven2-plugin-rat'."\n");
    # velocity descriptor bug
    $jpp->get_section('package','')->unshift_body('BuildRequires: velocity14'."\n");
}
__END__
