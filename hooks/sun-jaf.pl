#!/usr/bin/perl -w

push @SPECHOOKS, \&fix_jaf;

# until old jaf will be in Sisyphus
sub fix_jaf {
    my ($spec, $parent) = @_;
    $spec->get_section('package','')->unshift_body('Obsoletes: jaf = 1.0.2-alt2'."\n");
$spec->get_section('install')->push_body('
cat >>$RPM_BUILD_ROOT/%_altdir/jaf_%{name}<<EOF
%{_javadir}/activation.jar	%{_javadir}/%{name}-%version.jar	10100
EOF
');
    # slightly decrease the priority over glassfish-jaf
    $spec->get_section('install')->subst(qr'\.jar\s+10100','.jar	10099');

}

1;
