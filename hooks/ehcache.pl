#!/usr/bin/perl -w

# maven-artifact-ant problem :(
push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
};

__END__
5.0
require 'set_without_maven2.pl';
    $jpp->get_section('package','')->subst(qr'BuildRequires: checkstyle','BuildRequires: checkstyle4');
