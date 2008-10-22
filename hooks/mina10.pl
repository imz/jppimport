#require 'set_without_tests.pl';

__END__

38c38
< %define tests %{?_with_tests:1}%{!?_with_tests:%{?_without_tests:0}%{!?_without_tests:%{?_tests:%{_tests}}%{!?_tests:0}}}
---
> %define tests 0
220,231c220,231
< mvn-jpp -e \
<         -s ${M2SETTINGS} \
<         -Dmaven.repo.local=$MAVEN_REPO_LOCAL \
<         -Dmaven2.jpp.depmap.file=%{SOURCE2} \
<         javadoc:javadoc
< 
< mvn-jpp -e \
<         -s ${M2SETTINGS} \
<         -Dmaven.repo.local=$MAVEN_REPO_LOCAL \
<         -Dmaven2.jpp.depmap.file=%{SOURCE2} \
<         -N \
<         site
---
> #mvn-jpp -e \
> #        -s ${M2SETTINGS} \
> #        -Dmaven.repo.local=$MAVEN_REPO_LOCAL \
> #        -Dmaven2.jpp.depmap.file=%{SOURCE2} \
> #        javadoc:javadoc
> 
> #mvn-jpp -e \
> #        -s ${M2SETTINGS} \
> #        -Dmaven.repo.local=$MAVEN_REPO_LOCAL \
> #        -Dmaven2.jpp.depmap.file=%{SOURCE2} \
> #        -N \
> #        site
284,287c284,287
< install -d -m 0755 $RPM_BUILD_ROOT%{_javadocdir}/%{name}-%{version}
< cp -pr target/site/apidocs/* $RPM_BUILD_ROOT%{_javadocdir}/%{name}-%{version}
< ln -s %{name}-%{version} $RPM_BUILD_ROOT%{_javadocdir}/%{name} # ghost symlink
< rm -rf target/site/apidocs*
---
> #install -d -m 0755 $RPM_BUILD_ROOT%{_javadocdir}/%{name}-%{version}
> #cp -pr target/site/apidocs/* $RPM_BUILD_ROOT%{_javadocdir}/%{name}-%{version}
> #ln -s %{name}-%{version} $RPM_BUILD_ROOT%{_javadocdir}/%{name} # ghost symlink
> #rm -rf target/site/apidocs*
291c291
< cp -pr target/site/* $RPM_BUILD_ROOT%{_docdir}/%{name}-%{version}/
---
> #cp -pr target/site/* $RPM_BUILD_ROOT%{_docdir}/%{name}-%{version}/
298,305c298,305
< %post javadoc
< rm -f %{_javadocdir}/%{name}
< ln -s %{name}-%{version} %{_javadocdir}/%{name}
< 
< %postun javadoc
< if [ "$1" = "0" ]; then
<     rm -f %{_javadocdir}/%{name}
< fi
---
> #%post javadoc
> #rm -f %{_javadocdir}/%{name}
> #ln -s %{name}-%{version} %{_javadocdir}/%{name}
> 
> #%postun javadoc
> #if [ "$1" = "0" ]; then
> #    rm -f %{_javadocdir}/%{name}
> #fi
397,399c397,399
< %files javadoc
< %{_javadocdir}/%{name}-%{version}
< %ghost %{_javadocdir}/%{name}
---
> #%files javadoc
> #%{_javadocdir}/%{name}-%{version}
> #%ghost %{_javadocdir}/%{name}
401,402c401,402
< %files manual
< %{_docdir}/%{name}-%{version}
---
> #%files manual
> #%{_docdir}/%{name}-%{version}
