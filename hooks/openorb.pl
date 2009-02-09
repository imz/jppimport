#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    #due to Requires: jlfgr
    $jpp->disable_package('board');
    $jpp->get_section('package','')->subst_if('fop','xmlgraphics-fop',qr'Requires:');
    $jpp->get_section('build')->subst(qr'build-classpath xmlgraphics-fop','build-classpath xmlgraphics-fop');
}
