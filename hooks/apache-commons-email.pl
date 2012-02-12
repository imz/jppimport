#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
#    $jpp->get_section('package','')->unshift_body('BuildRequires: mojo-parent mojo-maven2-plugin-jdepend mojo-maven2-plugin-rat'."\n");
};

__END__
