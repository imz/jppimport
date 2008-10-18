#!/usr/bin/perl -w

# TODO: as a hook!
push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('BuildRequires: /usr/bin/dos2unix'."\n");
    $jpp->get_section('install')->push_body('dos2unix $RPM_BUILD_ROOT%_bindir/*'."\n");
}
