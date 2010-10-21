#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    # jbossas42 compat repolib
    $jpp->get_section('install')->push_body('
%if %with repolib
%define compatrepodir %{_javadir}/repository.jboss.com/glassfish/jsf/%{version_full}-brew
install -d -m 755 $RPM_BUILD_ROOT%{compatrepodir}/
ln -s $(relative %{repodir}/lib %{compatrepodir}/lib) $RPM_BUILD_ROOT%{compatrepodir}/lib
ln -s $(relative %{repodir}/src %{compatrepodir}/src) $RPM_BUILD_ROOT%{compatrepodir}/src
cp -a $RPM_BUILD_ROOT%{repodir}/component-info.xml $RPM_BUILD_ROOT%{compatrepodir}/component-info.xml
sed -i s,sun-jsf,glassfish/jsf, $RPM_BUILD_ROOT%{compatrepodir}/component-info.xml
%endif
');
};
__END__
