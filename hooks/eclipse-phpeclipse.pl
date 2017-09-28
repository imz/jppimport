#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($spec, $parent) = @_;
    # alt specific
    $spec->get_section('prep')->push_body(q'%__subst s,/usr/sbin/httpd,/usr/sbin/httpd2, net.sourceforge.phpeclipse.externaltools/prefs/default_linux.properties'."\n");
    $spec->get_section('package','')->subst_body_if(qr'php-pecl-xdebug','php5-xdebug',qr'Requires:');
    # altbug#13665
    $spec->get_section('package','')->subst_body(qr'Requires:\s*httpd','Requires: apache2');

    # 6u26
    #$spec->get_section('build')->subst_body(qr'pdebuild ','pdebuild -j "-Xmx1024m" ');

};

