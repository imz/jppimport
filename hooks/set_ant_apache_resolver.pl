#!/usr/bin/perl -w

$spechook = sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->subst(qr'ant-apache-resolver','ant-xml-resolver');
}
