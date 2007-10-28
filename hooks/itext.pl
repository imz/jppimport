#!/usr/bin/perl -w

push @SPECHOOKS, \&set_epoch_1;

sub set_epoch_1 {
    my ($jpp, $alt) = @_;
%_javadir/itext.jar
    # todo; skip jpackage-1.4-compat; 1.4 are in compile.xml
    $jpp->get_section('files','')->subst(qr'^%{_javadir}$','%{_javadir}/*.jar');
}
