#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    # jython :(
    $jpp->get_section('package','',)->push_body('%add_findreq_skiplist /usr/share/bsf-*'."\n");
    #$jpp->get_section('package','demo',)->push_body('AutoReq: yes,nopython'."\n");

    $jpp->get_section('install')->unshift_body_after(qr'__sed.+repodir.+/component-info.xml',
q!%{__sed} -i "s/@VERSION@/%{version}-brew/g" %{buildroot}%{repodir}/component-info.xml
!);
};
