#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
#    $jpp->get_section('package','')->unshift_body('BuildRequires: geronimo-annotation geronimo-interceptor'."\n");
};

__END__
    $jpp->get_section('package','')->push_body('
#Provides:       ejb = 0:3.1
#Provides:       ejb_api = 0:3.1
##Provides:       ejb_3_1_api = %{version}-%{release}
');

    $jpp->get_section('files','')->push_body(q!
#%_altdir/ejb_3_1_api_geronimo-ejb
#%_altdir/ejb_3_0_api_geronimo-ejb
#%_altdir/ejb_api_geronimo-ejb
%_altdir/ejb_geronimo-ejb
%exclude %{_javadir}*/ejb.jar
!."\n");

    $jpp->get_section('install')->push_body(q!
install -d $RPM_BUILD_ROOT/%_altdir; cat >$RPM_BUILD_ROOT/%_altdir/ejb_geronimo-ejb<<EOF
%{_javadir}/ejb.jar	%{_javadir}/geronimo-ejb.jar	30100
EOF
# install -d $RPM_BUILD_ROOT/%_altdir; cat >$RPM_BUILD_ROOT/%_altdir/ejb_api_geronimo-ejb<<EOF
# %{_javadir}/ejb_api.jar	%{_javadir}/geronimo-ejb.jar	30100
# EOF
# install -d $RPM_BUILD_ROOT/%_altdir; cat >$RPM_BUILD_ROOT/%_altdir/ejb_3_0_api_geronimo-ejb<<EOF
# %{_javadir}/ejb_3_0_api.jar	%{_javadir}/geronimo-ejb.jar	100
# EOF
# install -d $RPM_BUILD_ROOT/%_altdir; cat >$RPM_BUILD_ROOT/%_altdir/ejb_3_1_api_geronimo-ejb<<EOF
# %{_javadir}/ejb_3_1_api.jar	%{_javadir}/geronimo-ejb.jar	30100
# EOF
!."\n");

Provides:       ejb = 0:3.0
# TODO: drop asap
Provides:       ejb_3_0_api = %{version}-%{release}
Provides:       ejb_api = 0:3.0

%files -n geronimo-ejb-3.0-api
%_altdir/ejb_3_0_api_geronimo-ejb-3.0-api
%_altdir/ejb_api_geronimo-ejb-3.0-api
%_altdir/ejb_geronimo-ejb-3.0-api
%doc %{_docdir}/%{name}-%{version}/ejb-3.0/LICENSE.txt
%exclude %{_javadir}*/ejb.jar
%exclude %{_javadir}*/ejb_api.jar
%exclude %{_javadir}*/ejb_3_0_api.jar
%{_javadir}*/geronimo-ejb-3.0-api*.jar
