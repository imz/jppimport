#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
};

__END__
    $jpp->get_section('package','')->push_body('
#Provides:       jpa_3_0_api = %{version}-%{release}
#Provides:       jpa_api = 0:3.0
');

    $jpp->get_section('files','')->push_body(q!
#%_altdir/jpa_3_0_api_geronimo-jpa
#%_altdir/jpa_api_geronimo-jpa
!."\n");

    $jpp->get_section('install')->push_body(q!
#install -d $RPM_BUILD_ROOT/%_altdir; cat >$RPM_BUILD_ROOT/%_altdir/jpa_api_geronimo-jpa<<EOF
#%{_javadir}/jpa_api.jar	%{_javadir}/geronimo-jpa.jar	30100
#EOF
#install -d $RPM_BUILD_ROOT/%_altdir; cat >$RPM_BUILD_ROOT/%_altdir/jpa_3_0_api_geronimo-jpa<<EOF
#%{_javadir}/jpa_3_0_api.jar	%{_javadir}/geronimo-jpa.jar	30100
#EOF
!."\n");

%files -n geronimo-jpa-3.0-api
%_altdir/jpa_3_0_api_geronimo-jpa-3.0-api
%_altdir/jpa_api_geronimo-jpa-3.0-api
%{_javadir}*/geronimo-jpa-3.0-api*.jar
%doc %{_docdir}/%{name}-%{version}/jpa-3.0/LICENSE.txt
%exclude %{_javadir}*/jpa_api.jar
%exclude %{_javadir}*/jpa_3_0_api.jar
