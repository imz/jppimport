#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('build')->push_body(q!
# Build rss -- needed by struts
export CLASSPATH=$(build-classpath commons-beanutils commons-collections commons-logging junit)
CLASSPATH=${CLASSPATH}:`pwd`/target/%{short_name}-%{version}.jar
pushd src/examples/rss
%{ant} -Dant.build.javac.source=1.5 -Dant.build.javac.target=1.5 dist
popd
!."\n");

    # needed by betwixt
    $jpp->get_section('install')->push_body(q!# rss -- needed by struts
cp -p src/examples/rss/dist/%{short_name}-rss.jar $RPM_BUILD_ROOT%{_javadir}/%{name}-rss-%{version}.jar
ln -s %{name}-rss-%{version}.jar %{buildroot}%{_javadir}/%{name}-rss.jar
ln -s %{name}-rss-%{version}.jar %{buildroot}%{_javadir}/%{short_name}-rss-%{version}.jar
ln -s %{name}-rss-%{version}.jar %{buildroot}%{_javadir}/%{short_name}-rss.jar
ln -s %{name}-rss-%{version}.jar %{buildroot}%{_javadir}/jakarta-%{short_name}-rss-%{version}.jar
ln -s %{name}-rss-%{version}.jar %{buildroot}%{_javadir}/jakarta-%{short_name}-rss.jar
!."\n");
    $jpp->get_section('files','')->push_body(q!#%{_javadir}/*-rss*.jar!."\n");
};

__END__
