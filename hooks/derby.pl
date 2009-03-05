#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('BuildRequires: java-devel = 1.5.0'."\n");
    $jpp->get_section('package','')->unshift_body('BuildRequires: java-devel = 1.4.2'."\n");
};

__END__
