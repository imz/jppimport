#!/usr/bin/perl -w

$spechook = sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('Obsoletes: asm = 2.0-alt0.RC1'."\n");

    # TODO: investigate asm2-parent entry
    $jpp->get_section('install')->push_body('
mkdir -p $RPM_BUILD_ROOT/usr/share/maven2/default_poms/
pushd $RPM_BUILD_ROOT/usr/share/maven2/default_poms/
ln -s ../poms/JPP.asm2-parent.pom JPP-asm2-parent.pom
popd
');

    $jpp->get_section('files','')->push_body('/usr/share/maven2/default_poms/JPP-asm2-parent.pom
');

}
