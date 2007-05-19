#!/usr/bin/perl -w

require 'remove_java_devel.pl';

$spechook = sub {
    my ($jpp, $alt) = @_;
    #$jpp->get_section('build')->subst(qr'^j2ee-management','geronimo-j2ee-management-1.0-api');
    # hack around broken deps
    &remove_java_devel($jpp, $alt);
}
