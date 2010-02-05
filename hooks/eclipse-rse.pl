#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    # temp hack until we jump up to jpp6 and jakarta-commons-net 2
    # + MANUALLY added jakarta-commons-net
    $jpp->get_section('package','')->subst_if(qr'>= 0:2.0','','Requires:.*jakarta-commons-net');
};

