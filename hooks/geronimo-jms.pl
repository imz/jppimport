#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
};
__END__
    $jpp->get_section('package','')->push_body('
#Provides:       jms_1_1_api = %{version}-%{release}
#Provides:       jms_api = 0:1.1
# drop the following asap
#Provides:       jms = 0:1.1
');

    $jpp->get_section('files','')->push_body(q!
#%_altdir/jms_1_1_api_geronimo-jms
#%_altdir/jms_api_geronimo-jms
%_altdir/jms_geronimo-jms
%exclude %{_javadir}*/jms.jar
!."\n");

    $jpp->get_section('install')->push_body(q!
install -d $RPM_BUILD_ROOT/%_altdir; cat >$RPM_BUILD_ROOT/%_altdir/jms_geronimo-jms<<EOF
%{_javadir}/jms.jar	%{_javadir}/geronimo-jms.jar	10200
EOF
#install -d $RPM_BUILD_ROOT/%_altdir; cat >$RPM_BUILD_ROOT/%_altdir/jms_api_geronimo-jms<<EOF
#%{_javadir}/jms_api.jar	%{_javadir}/geronimo-jms.jar	10200
#EOF
#install -d $RPM_BUILD_ROOT/%_altdir; cat >$RPM_BUILD_ROOT/%_altdir/jms_1_1_api_geronimo-jms<<EOF
#%{_javadir}/jms_1_1_api.jar	%{_javadir}/geronimo-jms.jar	10200
#EOF
!."\n");

Provides:       jms_1_1_api = %{version}-%{release}
Provides:       jms_api = 0:1.1
# drop the following asap
Provides:       jms = 0:1.1

%files -n geronimo-jms-1.1-api
%_altdir/jms_1_1_api_geronimo-jms-1.1-api
%_altdir/jms_api_geronimo-jms-1.1-api
%_altdir/jms_geronimo-jms-1.1-api
%{_javadir}*/geronimo-jms-1.1-api*.jar
%doc %{_docdir}/%{name}-%{version}/jms-1.1/LICENSE.txt
%exclude %{_javadir}*/jms.jar
%exclude %{_javadir}*/jms_api.jar
%exclude %{_javadir}*/jms_1_1_api.jar
