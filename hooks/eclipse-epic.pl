#!/usr/bin/perl -w
#require 'set_noarch.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->subst(qr'PadWalker','PadWalker.pm');
    $jpp->get_section('package','')->subst(qr'Module::Starter','Module/Starter.pm');
};

