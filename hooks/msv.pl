#!/usr/bin/perl -w

$spechook = sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('%define _bootstrap 1'."\n");
    # tmp hack due to alt xml-commons-resolver 1.1
    $jpp->get_section('package','')->subst(qr'BuildRequires:\s*xml-commons-resolver','BuildRequires: xml-commons-resolver12');

    $jpp->set_changelog('- imported with jppimport script; note: bootstrapped version')
}
