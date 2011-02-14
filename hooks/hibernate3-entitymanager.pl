#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
};
__END__
#jpp5.0
    $jpp->get_section('package','')->unshift_body('BuildRequires: hsqldb'."\n");
