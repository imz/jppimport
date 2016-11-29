#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($spec, $parent) = @_;
    # jbossas42 compat repolib
    $spec->get_section('install')->push_body('
%if %with repolib
%define compatrepodir %{_javadir}/repository.jboss.com/glassfish/jaf/%{version}-brew
install -d -m 755 $RPM_BUILD_ROOT%{compatrepodir}/
ln -s $(relative %{repodir}/lib %{compatrepodir}/lib) $RPM_BUILD_ROOT%{compatrepodir}/lib
ln -s $(relative %{repodir}/src %{compatrepodir}/src) $RPM_BUILD_ROOT%{compatrepodir}/src
cp -a $RPM_BUILD_ROOT%{repodir}/component-info.xml $RPM_BUILD_ROOT%{compatrepodir}/component-info.xml
sed -i s,sun-jaf,glassfish/jaf, $RPM_BUILD_ROOT%{compatrepodir}/component-info.xml
%endif
');
};
__END__
