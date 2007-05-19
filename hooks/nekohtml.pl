#!/usr/bin/perl -w

$spechook = sub {
    my ($jpp, $alt) = @_;
# bugfix; to be commited in bugzilla
    $jpp->get_section('files','')->subst(qr'^\%doc ','%doc --no-dereference ');
}
