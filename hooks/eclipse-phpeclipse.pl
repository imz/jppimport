#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    # alt specific
    $jpp->get_section('prep')->push_body(qr'%__subst s,/usr/sbin/httpd,/usr/sbin/httpd2, net.sourceforge.phpeclipse.externaltools/prefs/default_linux.properties'."\n");
    $jpp->get_section('package','')->subst_if(qr'php-pecl-xdebug','php5-xdebug',qr'Requires:');
    # altbug#13665
    $jpp->get_section('package','')->subst(qr'Requires:\s*httpd','Requires: apache2');

    # 6u26
    #$jpp->get_section('build')->subst(qr'pdebuild ','pdebuild -j "-Xmx1024m" ');

};

