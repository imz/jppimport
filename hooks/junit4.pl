#!/usr/bin/perl -w

require 'set_osgi.pl';

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;

    # drop junit4-* provides/obsoletes
    $jpp->main_section->exclude_body(qr'^(Provides|Obsoletes):\s+junit4');

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

    $jpp->get_section('description','manual')->push_body('
%package -n junit-junit4
Group:          Development/Java
Summary:        %{oldname} provider
BuildArch: noarch
Requires: %name = %epoch:%{version}-%{release}
#Provides: junit = 0:%{version}
#Provides: junit = %{epoch}:%{version}-%{release}
#Provides: %_javadir/junit.jar

%description -n junit-junit4
Virtual junit package based on %{name}.

');
    $jpp->get_section('files','manual')->push_body('
%files -n junit-junit4
%_altdir/%{name}
');
    $jpp->get_section('install')->push_body('
mkdir -p %buildroot%_altdir
cat >>%buildroot%_altdir/%{name}<<EOF
%{_javadir}/junit.jar	%{_javadir}/%{name}.jar	4100
EOF
');

};

__END__
