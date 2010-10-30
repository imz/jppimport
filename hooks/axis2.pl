#!/usr/bin/perl -w

push @SPECHOOKS, 

sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('BuildRequires: geronimo-jms-1.1-api geronimo-javamail-1.4-api'."\n");
    # TODO:
    # it looks like circular dependency; we need axis2-jaxws-2.0-api to be built with
    # and poms should be fixed accordingly.
    #$jpp->get_section('package','')->unshift_body('BuildRequires: axis2'."\n");

    #$jpp->disable_package('codegen-eclipse-plugin');
    #$jpp->disable_package('service-archiver-eclipse-plugin');

#subst s,'ln -sf %{_datadir}/eclipse,ln -sf %{_libdir}/eclipse,' axis2.spec
    $jpp->get_section('build')->subst(qr'ln -sf \%{_datadir}/eclipse','ln -sf %{_libdir}/eclipse');
}

__END__
