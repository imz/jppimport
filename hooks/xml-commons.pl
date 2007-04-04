#!/usr/bin/perl -w

$spechook = sub {
    my ($jpp, $alt) = @_;
# bugfix; to be commited in bugzilla
    $jpp->get_section('package','jaxp-1.2-apis-javadoc')->subst(qr'%{epocj}','%{epoch}');
}
