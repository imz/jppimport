#!/usr/bin/perl -w

require 'set_clean_surefire23.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->subst_if(qr' < 0:1.0-0.3.a11','',qr'BuildRequires');
}

# manual
# -Dmaven.test.skip=true
