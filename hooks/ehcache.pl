#!/usr/bin/perl -w

# maven-artifact-ant problem :(
require 'set_without_maven2.pl';
push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->subst(qr'BuildRequires: checkstyle','BuildRequires: checkstyle4');
};

__END__
