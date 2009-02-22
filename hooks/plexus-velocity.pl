#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('Requires: jakarta-commons-logging'."\n");
    $jpp->get_section('package','')->unshift_body('BuildRequires: jakarta-commons-logging'."\n");
    $jpp->get_section('package','')->unshift_body('BuildRequires: maven-shared-archiver'."\n");
}

__END__
by hands: removed maven-archiver depmap entry
