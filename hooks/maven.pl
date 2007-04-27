#!/usr/bin/perl -w

$spechook = sub {
    my ($jpp, $alt) = @_;
    # ALT Compat provides
    # hack around alt ant deps
    $jpp->get_section('package','')->subst(qr'BuildRequires:\s*ant-apache-bcel','BuildRequires: ant-bcel');
    $jpp->get_section('package','')->subst(qr'BuildRequires:\s*ant-apache-oro','BuildRequires: ant-jakarta-oro');
    $jpp->get_section('package','')->subst(qr'BuildRequires:\s*ant-apache-regexp','BuildRequires: ant-jakarta-regexp');
    $jpp->get_section('package','')->subst(qr'BuildRequires:\s*ant-apache-log4j','BuildRequires: ant-log4j');
    $jpp->get_section('package','')->subst(qr'BuildRequires:\s*ant-apache-bcel','BuildRequires: ant-bcel');
}
__END__
BuildRequires: ant-apache-resolver >= 0:1.6.2
BuildRequires: ant-nodeps
BuildRequires: ant-swing >= 0:1.6.2
BuildRequires: dom4j >= 0:1.5-1jpp
BuildRequires: forehead >= 0:1.0.b4-4jpp
BuildRequires: jakarta-commons-beanutils16 >= 0:1.6.1
BuildRequires: jakarta-commons-betwixt >= 0:1.0-0.alpha1.4jpp
BuildRequires: jakarta-commons-cli >= 1.0
BuildRequires: jakarta-commons-collections >= 0:3.1-1jpp
BuildRequires: jakarta-commons-digester >= 0:1.7
BuildRequires: jakarta-commons-grant >= 0:1.0.b4
BuildRequires: jakarta-commons-graph >= 0:0.8.1
BuildRequires: jakarta-commons-httpclient >= 2.0
BuildRequires: jakarta-commons-io >= 1.1
BuildRequires: jakarta-commons-jelly >= 0:1.0-0.b4.6jpp
BuildRequires: jakarta-commons-jelly-tags-ant >= 0:1.0-0.b4.6jpp
BuildRequires: jakarta-commons-jelly-tags-define >= 0:1.0-0.b4.6jpp
BuildRequires: jakarta-commons-jelly-tags-util >= 0:1.0-0.b4.6jpp
BuildRequires: jakarta-commons-jelly-tags-xml >= 0:1.0-0.b4.6jpp
BuildRequires: jakarta-commons-jexl >= 0:1.0
BuildRequires: jakarta-commons-logging >= 0:1.0.3
BuildRequires: jline >= 0.8.1
BuildRequires: jaxen >= 0:1.1
#BuildRequires: junit >= 0:3.8.1
BuildRequires: log4j >= 0:1.2.8
BuildRequires: maven-model >= 3.0.1
BuildRequires: maven-wagon >= 1.0
BuildRequires: plexus-container-default >= 0:1.0
BuildRequires: plexus-utils >= 1.0.4
BuildRequires: plexus-velocity >= 0:1.1.2
BuildRequires: werkz >= 1.0-0.b10.5jpp
#BuildRequires: xerces-j2 >= 0:2.6.2
Requires: xml-commons-apis
Requires: xml-commons-which


