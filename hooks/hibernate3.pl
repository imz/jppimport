#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    # tested in jpp6
    $jpp->get_section('package','')->unshift_body('BuildRequires: docbook-dtds'."\n");
    $jpp->get_section('install')->push_body('# compat symlink
ln -s hibernate3/hibernate-core.jar %buildroot%_javadir/hibernate3.jar
');
    $jpp->get_section('files')->unshift_body('%_javadir/hibernate3.jar'."\n");
};

1;
