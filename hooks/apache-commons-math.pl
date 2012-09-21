#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('BuildRequires: maven-antrun-plugin'."\n");
    # no, no need for a compat symlink. math3 namespace :(
};

__END__
