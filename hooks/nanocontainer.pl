#!/usr/bin/perl -w

require 'set_maven_notests.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    # bug to report
    $jpp->get_section('install')->subst(qr'ln -sf %{_javadir}/nanocontainer-booter.jar','ln -sf %{_javadir}/nanocontainer/booter.jar');

    # no more in jetty6
    $jpp->get_section('package'.'')->subst(qr'BuildRequires: jetty6-jsp-2.1','BuildRequires: jsp_2_1_api');
    $jpp->get_section('package'.'webcontainer')->exclude(qr'Requires: jetty6-*.-api');

}

__END__
# TODO:
#skipped some depmap hacking; see SRPM
