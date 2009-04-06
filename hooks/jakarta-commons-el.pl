#!/usr/bin/perl -w

require 'set_epoch_1.pl';

push @SPECHOOKS, sub  {
    my ($jpp, $alt) = @_;
    # no one that provides jsp has jspapi alternative :(
    #$jpp->get_section('prep')->subst_if(qr'jspapi','jsp',qr'build-classpath');
}
