#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    # 2.2-2
    $jpp->get_section('package','')->unshift_body('BuildRequires: xpp3-minimal'."\n");
    $jpp->get_section('package','')->unshift_body('Requires: xpp3-minimal'."\n");
};

__END__
