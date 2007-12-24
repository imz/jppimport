#!/usr/bin/perl -w

$spechook = \&fix_jaf;

# until old jaf will be in Sisyphus
sub fix_jaf {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('Obsoletes: jaf = 1.0.2-alt2'."\n");
$jpp->get_section('install')->push_body('
cat >>$RPM_BUILD_ROOT/%_altdir/jaf_%{name}<<EOF
%{_javadir}/activation.jar	%{_javadir}/%{name}-%version.jar	%{_javadir}/%{name}.jar
EOF
');
}

1;
