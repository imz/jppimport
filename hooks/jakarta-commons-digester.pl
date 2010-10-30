#!/usr/bin/perl -w

push @SPECHOOKS, 
 sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('install')->unshift_body_after('%{__sed} -i "s/@VERSION@/%{version}-brew/g" %{buildroot}%{repodir}/component-info.xml'."\n", qr's/@TAG@/');
    $jpp->get_section('package','')->push_body('
Provides: jakarta-commons-digester18 = %version
Obsoletes: jakarta-commons-digester18 < %version
');
}
