#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
#    $jpp->get_section('build')->subst_if(qr'jss','jss4',qr'build-classpath');
    $jpp->get_section('install')->push_body(q!ln -s ldapjdk.jar %buildroot%_javadir/ldapsdk.jar!."\n");
    $jpp->get_section('files')->push_body(q!%_javadir/ldapsdk.jar!."\n");
    $jpp->get_section('package','')->push_body(q!
Provides: ldapsdk = 1:%version-%release
Obsoletes: ldapsdk <= 1:4.18-alt1_2jpp6
!."\n");
};

__END__
