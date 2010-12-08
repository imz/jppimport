#!/usr/bin/perl -w
push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('prep')->subst(qr'ws-commons-util-1.0.1.jar','ws-commons-util.jar');
    $jpp->get_section('install')->subst(qr'ws-commons-util-1.0.1.jar','ws-commons-util.jar');
};
__END__
