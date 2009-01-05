#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    # TODO: detect and remove such lines in jppimport.
    # first it could be grepped in existing specs...
    # and if all matches will be bad, it worth including in jppimport
    #touch $RPM_BUILD_ROOT%{_javadir}/qname.jar # for %ghost
    # lools like generic hack/hook
    $jpp->get_section('install')->subst_if(qr'^\s*touch','#touch', qr'for %ghost');

    # oh, they did it too (as of jpp 5)
    #%exclude %{_javadir}/qname.jar
    $jpp->get_section('files','')->subst_if(qr'^\s*%exclude','#exclude', qr'/qname.jar');
}
