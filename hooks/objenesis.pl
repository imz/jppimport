#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    # tmp fix
    $jpp->get_section('package','')->unshift_body('BuildRequires: sun-annotation-1.0-api'."\n");
};

__END__
