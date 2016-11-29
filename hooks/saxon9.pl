#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($spec, $parent) = @_;
    # common problem for all saxones
    $spec->get_section('install')->push_body('chmod 755 $RPM_BUILD_ROOT%{_bindir}/*'."\n");
    $spec->get_section('prep')->subst(qr'^cd /builddir/build/BUILD','cd %_builddir');
};

