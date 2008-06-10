#!/usr/bin/perl -w

$spechook = sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body(q'BuildRequires: gcc-c++ eclipse-ecj libstdc++-devel-static
');
    $jpp->get_section('package','')->subst(qr'java-1.5.0-gcj-devel','java-1.6.0-sun-devel');
    $jpp->get_section('package','')->subst(qr'java-1.6.0-openjdk-devel','java-1.6.0-sun-devel');
    $jpp->get_section('package','')->subst(qr'java-1.6.0-openjdk-devel','java-1.6.0-sun-devel');
    $jpp->get_section('package','')->subst(qr'gecko-devel','firefox-devel');
    $jpp->get_section('package','')->subst(qr'^Epoch:\s+1','Epoch: 0');

    $jpp->copy_to_sources('java-1.6.0-openjdk-alt-ldflag.patch');
    $jpp->copy_to_sources('java-1.6.0-openjdk-alt-as-needed1.patch');
    $jpp->get_section('package','')->unshift_body(q{
Patch33: java-1.6.0-openjdk-alt-ldflag.patch
Patch34: java-1.6.0-openjdk-alt-as-needed1.patch
});

    $jpp->get_section('build')->unshift_body('unset JAVA_HOME'."\n");
    $jpp->get_section('build')->subst(qr'./configure','./configure --with-openjdk-home=/usr/lib/jvm/java');
    #$jpp->get_section('build')->subst(qr'^make\s*$','make OTHER_LDFAGS="-L /usr/lib/jvm/jre/lib/amd64/server -L /usr/lib/jvm/jre/lib/amd64"'."\n");
    $jpp->get_section('build')->unshift_body_after(q'patch -p1 < %{PATCH33}
patch -p1 < %{PATCH34}
',qr'{PATCH2}');

    $jpp->get_section('install')->unshift_body('unset JAVA_HOME'."\n");
    $jpp->get_section('install')->subst(qr'mv bin/java-rmi.cgi sample/rmi','#mv bin/java-rmi.cgi sample/rmi');
    $jpp->get_section('install')->unshift_body_after('install -D -m644 $e.desktop $RPM_BUILD_ROOT%{_datadir}/applications'."\n",qr'for e in jconsole policytool');
    $jpp->get_section('install')->unshift_body_after('install -D -m644 javaws.desktop $RPM_BUILD_ROOT%{_datadir}/applications'."\n",qr'cp javaws.png');
    $jpp->get_section('install')->subst(qr'desktop-file-install','#desktop-file-install');
    $jpp->get_section('install')->subst(qr'--dir( |=)$RPM_BUILD_ROOT','#--dir $RPM_BUILD_ROOT');

}
