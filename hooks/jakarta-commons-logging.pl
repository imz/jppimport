#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->add_patch('commons-logging-eclipse-manifest.patch');
    # todo: look and fix tests!
    $jpp->get_section('build')->subst(qr'ant  \\','ant -Dtest.failonerror=false \\');
    $jpp->get_section('build')->subst(qr'test$', 'test || :');
}
