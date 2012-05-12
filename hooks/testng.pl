#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('Requires: oss-parent'."\n");
    $jpp->get_section('package','')->unshift_body('BuildRequires: oss-parent'."\n");
};

__END__
