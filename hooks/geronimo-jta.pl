#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
};

__END__
    $jpp->get_section('package','')->push_body('
#Provides:       jta_1_1_api = %{version}-%{release}
#Provides:       jta_api = 0:1.1
# drop asap
#Provides:       jta = 0:1.1
');

    $jpp->get_section('files','')->push_body(q!
#%_altdir/jta_1_1_api_geronimo-jta
#%_altdir/jta_api_geronimo-jta
%_altdir/jta_geronimo-jta
%exclude %{_javadir}*/jta.jar
!."\n");

    $jpp->get_section('install')->push_body(q!
install -d $RPM_BUILD_ROOT/%_altdir; cat >$RPM_BUILD_ROOT/%_altdir/jta_geronimo-jta<<EOF
%{_javadir}/jta.jar	%{_javadir}/geronimo-jta.jar	10200
EOF
#install -d $RPM_BUILD_ROOT/%_altdir; cat >$RPM_BUILD_ROOT/%_altdir/jta_api_geronimo-jta<<EOF
#%{_javadir}/jta_api.jar	%{_javadir}/geronimo-jta.jar	10200
#EOF
#install -d $RPM_BUILD_ROOT/%_altdir; cat >$RPM_BUILD_ROOT/%_altdir/jta_1_1_api_geronimo-jta<<EOF
#%{_javadir}/jta_1_1_api.jar	%{_javadir}/geronimo-jta.jar	10200
#EOF
!."\n");
%files -n geronimo-jta-1.1-api
%_altdir/jta_1_1_api_geronimo-jta-1.1-api
%_altdir/jta_api_geronimo-jta-1.1-api
%_altdir/jta_geronimo-jta-1.1-api
%{_javadir}*/geronimo-jta-1.1-api*.jar
%doc %{_docdir}/%{name}-%{version}/jta-1.1/LICENSE.txt
%exclude %{_javadir}*/jta.jar
%exclude %{_javadir}*/jta_api.jar
%exclude %{_javadir}*/jta_1_1_api.jar
