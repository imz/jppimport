#!/usr/bin/perl -w

require 'set_target_14.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    # strange problem with javadoc
    $jpp->disable_package('javadoc');
    $jpp->get_section('prep')->push_body(q!
sed -i -e 's,http://xdoclet.sourceforge.net/dtds/xtags_1_1.dtd,'`pwd`/'xdocs/dtds/xtags_1_1.dtd,' `grep -rl 'http://xdoclet.sourceforge.net/dtds/xtags_1_1.dtd' .`
!);
    $jpp->get_section('install')->subst(qr'cp -pr target/docs/api',"#cp -pr target/docs/api");
};

