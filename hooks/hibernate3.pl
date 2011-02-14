#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('BuildRequires: docbook-xml docbook-dtds'."\n");
    $jpp->get_section('package','')->unshift_body('BuildRequires: backport-util-concurrent'."\n");
    $jpp->get_section('install')->push_body('# compat symlink
ln -s hibernate3-core.jar %buildroot%_javadir/hibernate3.jar
');
    $jpp->get_section('files')->unshift_body('%_javadir/hibernate3.jar'."\n");
};

1;
