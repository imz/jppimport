#!/usr/bin/perl -w

$spechook = sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('BuildRequires: jakarta-commons-logging'."\n");
#    $jpp->get_section('build')->unshift_body('export ANT_OPTS="$ANT_OPTS -Xms512m -Xmx2048m -Xss1m"'."\n");

}
