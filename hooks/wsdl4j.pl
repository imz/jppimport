#!/usr/bin/perl -w

$spechook = sub {
    my ($jpp, $alt) = @_;
    # TODO: detect and remove such lines in jppimport.
    # first it could be grepped in existing specs...
    # and if all matches will be bad, it worth including in jppimport
    #touch $RPM_BUILD_ROOT%{_javadir}/qname.jar # for %ghost
    # lools like generic hack/hook
    $jpp->get_section('install')->subst_if(qr'^\s*touch','#touch', qr'for %ghost');
}
