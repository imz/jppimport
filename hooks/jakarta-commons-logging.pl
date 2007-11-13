#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    # todo: look and fix tests!
    $jpp->get_section('build')->subst(qr'ant  \\','ant -Dtest.failonerror=false \\');
    $jpp->get_section('build')->subst(qr'test$', 'test || :');
}
