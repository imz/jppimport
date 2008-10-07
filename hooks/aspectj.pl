#!/usr/bin/perl -w

push @SPECHOOKS, 
 sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('build')->subst(qr'-Xmx384','-Xmx1024');
    $jpp->get_section('files','eclipse-plugins')->push_body(q'%_datadir/eclipse/plugins/org.aspect*
'); 
}
