#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('BuildRequires: velocity14 qdox16-poms commons-primitives'."\n");
    $jpp->get_section('package','')->unshift_body('BuildRequires: maven-shared-downloader'."\n");
}
__END__
