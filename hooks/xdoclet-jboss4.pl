#!/usr/bin/perl -w

require 'set_target_14.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    # strange problem with javadoc
    $jpp->disable_package('javadoc');
    $jpp->get_section('install')->subst(qr'cp -pr target/docs/api',"#cp -pr target/docs/api");
};

