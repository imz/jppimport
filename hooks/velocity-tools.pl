#!/usr/bin/perl -w

#require 'set_without_demo.pl';
#require 'set_target_14.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
#1.7
#    # strange problem with javadoc
#    $jpp->disable_package('javadoc');
#    $jpp->get_section('install')->subst(qr'cp -pr dist/site/apidocs',"#cp -pr dist/site/apidocs");
};

