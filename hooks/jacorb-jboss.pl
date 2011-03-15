#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('install')->push_body(q!
# hack (2.3.1-5)
sed -i s,$RPM_BUILD_DIR/jacorb-%{version}/bin,%{_datadir}/%{name}-%{version}/bin,g %buildroot/usr/share/jacorb-jboss-2.3.1/bin/ntfy-wrapper
sed -i s,$RPM_BUILD_DIR/jacorb-%{version}/bin,%{_datadir}/%{name}-%{version}/bin,g %buildroot/usr/share/jacorb-jboss-2.3.1/bin/ns-wrapper
!);
}
__END__
