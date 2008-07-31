#!/usr/bin/perl -w

require 'set_fix_eclipse_dep.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    # alt specific
    $jpp->get_section('prep')->push_body(qr'%__subst s,/usr/sbin/httpd,/usr/sbin/httpd2, net.sourceforge.phpeclipse.externaltools/prefs/default_linux.properties'."\n");
    $jpp->get_section('package','')->subst(qr'Requires:\s*php >= 5','Requires: php5');
    # altbug#13665
    $jpp->get_section('package','')->subst(qr'Requires:\s*httpd','Requires: apache2');
};

