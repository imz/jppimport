#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('BuildRequires: geronimo-saaj'."\n");
    $jpp->get_section('package','')->push_body('
#Provides:       jaxrpc = 0:1.1
#Provides:       jaxrpc_1_1_api = %{version}-%{release}
#Provides:       jaxrpc_api = 0:1.1
');

    $jpp->get_section('files','')->push_body(q!
#%_altdir/jaxrpc_1_1_api_geronimo-jaxrpc
#%_altdir/jaxrpc_api_geronimo-jaxrpc
%_altdir/jaxrpc_geronimo-jaxrpc
%exclude %{_javadir}*/jaxrpc.jar
!."\n");

    $jpp->get_section('install')->push_body(q!
install -d $RPM_BUILD_ROOT/%_altdir; cat >$RPM_BUILD_ROOT/%_altdir/jaxrpc_geronimo-jaxrpc<<EOF
%{_javadir}/jaxrpc.jar	%{_javadir}/geronimo-jaxrpc.jar	10000
EOF
#install -d $RPM_BUILD_ROOT/%_altdir; cat >$RPM_BUILD_ROOT/%_altdir/jaxrpc_api_geronimo-jaxrpc<<EOF
#%{_javadir}/jaxrpc_api.jar	%{_javadir}/geronimo-jaxrpc.jar	10000
#EOF
#install -d $RPM_BUILD_ROOT/%_altdir; cat >$RPM_BUILD_ROOT/%_altdir/jaxrpc_1_1_api_geronimo-jaxrpc<<EOF
#%{_javadir}/jaxrpc_1_1_api.jar	%{_javadir}/geronimo-jaxrpc.jar	10000
#EOF
!."\n");
};

__END__

Provides:       jaxrpc = 0:1.1
# TODO: drop asap
Provides:       jaxrpc_1_1_api = %{version}-%{release}
Provides:       jaxrpc_api = 0:1.1

%files -n geronimo-jaxrpc-1.1-api
%_altdir/jaxrpc_1_1_api_geronimo-jaxrpc-1.1-api
%_altdir/jaxrpc_api_geronimo-jaxrpc-1.1-api
%_altdir/jaxrpc_geronimo-jaxrpc-1.1-api
%{_javadir}*/geronimo-jaxrpc-1.1-api*.jar
%exclude %{_javadir}*/jaxrpc.jar
%exclude %{_javadir}*/jaxrpc_api.jar
%exclude %{_javadir}*/jaxrpc_1_1_api.jar
