#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('BuildRequires: xmldb-api-sdk'."\n");
    $jpp->get_section('package','')->unshift_body('Requires: xmldb-api-sdk'."\n");
    # ALT compat (is it needed at all?) 
    $jpp->get_section('install')->push_body('pushd $RPM_BUILD_ROOT/%{_javadir}; ln -s %{base_name} ws-jaxme; popd'."\n");
    # hack around hsqldb and dual core CPU
    $jpp->get_section('build')->subst(qr'ant all javadoc', "ant all\nant javadoc");
}
