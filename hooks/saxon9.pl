#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    # common problem for all saxones
    $jpp->get_section('install')->push_body('chmod 755 $RPM_BUILD_ROOT%{_bindir}/*'."\n");
    $jpp->get_section('prep')->subst(qr'^cd /builddir/build/BUILD','cd %_builddir');
};

