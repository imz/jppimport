#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
};

__END__
--- jung2.spec.0        2012-03-15 19:01:39.196563168 +0000
+++ jung2.spec  2012-03-15 19:03:41.760102995 +0000
@@ -143,12 +143,10 @@
 export MAVEN_OPTS="-Dmaven2.jpp.mode=true -Dmaven2.jpp.depmap.file=%{SOURCE2} -Dmaven.repo.local=${MAVEN_REPO_LOCAL} -Djava.awt.headless=true"
 %{_bindir}/mvn-jpp \
         -e \
-        -s $(pwd)/settings.xml \
         install

 %{_bindir}/mvn-jpp \
         -e \
-        -s $(pwd)/settings.xml \
         javadoc:javadoc
 #site

@@ -198,7 +196,7 @@
     $RPM_BUILD_ROOT%{_datadir}/maven2/poms/JPP.%{name}-visualization.pom

 install -d -m 755 $RPM_BUILD_ROOT%{_javadocdir}/%{name}-%{version}
-cp -pr target/site/apidocs/* $RPM_BUILD_ROOT%{_javadocdir}/%{name}-%{version}/
+#cp -pr target/site/apidocs/* $RPM_BUILD_ROOT%{_javadocdir}/%{name}-%{version}/
 ln -s %{name}-%{version} $RPM_BUILD_ROOT%{_javadocdir}/%{name} # ghost symlink

 %if %{gcj_support}
