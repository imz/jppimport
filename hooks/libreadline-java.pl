#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($spec,) = @_;
    $spec->get_section('prep','')->push_body('%__subst s,termcap,tinfo, src/native/Makefile'."\n");
}
__END__
$spec->get_section('package','')->subst_body(qr'%{_libdir}/libtermcap.so', 'libtinfo-devel');
#    $spec->get_section('package','')->subst_body(qr'^Requires: readline', '##Requires: readline');
#    $spec->get_section('package','')->subst_body(qr'readline-devel', 'libreadline-devel');
