#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;

    # TODO: drop junit4-* provides/obsoletes

    $jpp->spec_apply_patch(PATCHSTRING=>q!
--- junit.spec	2012-08-30 00:56:04.000000000 +0300
+++ junit.spec	2012-08-30 00:59:16.000000000 +0300
@@ -122,39 +122,39 @@
 %install
 # jars
 install -d -m 755 %{buildroot}%{_javadir}
-install -m 644 %{oldname}%{version}/%{oldname}-%{version}.jar %{buildroot}%{_javadir}/%{oldname}.jar
+install -m 644 %{oldname}%{version}/%{oldname}-%{version}.jar %{buildroot}%{_javadir}/%{name}.jar
 # Many packages still use the junit4.jar directly
-ln -s %{_javadir}/%{oldname}.jar %{buildroot}%{_javadir}/%{oldname}4.jar
+ln -s %{_javadir}/%{name}.jar %{buildroot}%{_javadir}/%{oldname}.jar
 
 # pom
 install -d -m 755 %{buildroot}%{_mavenpomdir}
-install -m 644 pom.xml %{buildroot}%{_mavenpomdir}/JPP-%{oldname}.pom
-%add_maven_depmap JPP-%{oldname}.pom %{oldname}.jar
+install -m 644 pom.xml %{buildroot}%{_mavenpomdir}/JPP-%{name}.pom
+%add_maven_depmap JPP-%{name}.pom %{name}.jar
 
 # javadoc
-install -d -m 755 %{buildroot}%{_javadocdir}/%{oldname}
-cp -pr %{oldname}%{version}/javadoc/* %{buildroot}%{_javadocdir}/%{oldname}
+install -d -m 755 %{buildroot}%{_javadocdir}/%{name}
+cp -pr %{oldname}%{version}/javadoc/* %{buildroot}%{_javadocdir}/%{name}
 
 # demo
-install -d -m 755 %{buildroot}%{_datadir}/%{oldname}/demo/%{oldname} 
+install -d -m 755 %{buildroot}%{_datadir}/%{name}/demo/%{name} 
 
-cp -pr %{oldname}%{version}/%{oldname}/* %{buildroot}%{_datadir}/%{oldname}/demo/%{oldname}
+cp -pr %{oldname}%{version}/%{oldname}/* %{buildroot}%{_datadir}/%{name}/demo/%{name}
 
 
 %files
 %doc cpl-v10.html README.html
-%{_javadir}/%{oldname}.jar
-%{_javadir}/%{oldname}4.jar
+#%{_javadir}/%{oldname}.jar
+%{_javadir}/%{name}.jar
 %{_mavenpomdir}/*
 %{_mavendepmapfragdir}/*
 
 %files demo
 %doc cpl-v10.html
-%{_datadir}/%{oldname}
+%{_datadir}/%{name}
 
 %files javadoc
 %doc cpl-v10.html
-%doc %{_javadocdir}/%{oldname}
+%doc %{_javadocdir}/%{name}
 
 %files manual
 %doc cpl-v10.html
!);
};

__END__
