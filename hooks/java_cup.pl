#!/usr/bin/perl -w

$spechook = sub {
    my ($jpp, $alt) = @_;
# bugfix; to be commited in bugzilla
    $jpp->get_section('package','')->subst(qr'\%7Eappel','%%7Eappel');
}
