#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('prep','')->push_body('%__subst s,termcap,tinfo, src/native/Makefile'."\n");
}
__END__
$jpp->get_section('package','')->subst(qr'%{_libdir}/libtermcap.so', 'libtinfo-devel');
#    $jpp->get_section('package','')->subst(qr'^Requires: readline', '##Requires: readline');
#    $jpp->get_section('package','')->subst(qr'readline-devel', 'libreadline-devel');
