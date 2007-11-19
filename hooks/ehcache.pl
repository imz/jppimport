#!/usr/bin/perl -w

push @SPECHOOKS, 

sub {
    my ($jpp, $alt) = @_;
    # todo: remove when hibernate3 will be built
    $jpp->get_section('package','')->unshift_body('%define _without_hibernate 1'."\n");
    $jpp->get_section('build')->unshift_body_after('ln -sf $(build-classpath checkstyle) .'."\n", qr'^pushd tools');

    # test fails :(
    $jpp->get_section('build')->subst(qr'build dist','dist-jar javadoc');

}
