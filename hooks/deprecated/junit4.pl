#!/usr/bin/perl -w

require 'set_osgi.pl';

push @SPECHOOKS, 
sub {
    my ($spec,) = @_;

    # drop junit4-* provides/obsoletes
    $spec->main_section->exclude_body(qr'^(Provides|Obsoletes):\s+junit4');

    $spec->spec_apply_patch(PATCHSTRING=>q!
--- junit.spec	2014-07-10 13:42:48.000000000 +0300
+++ junit.spec	2014-07-10 13:48:17.000000000 +0300
@@ -117,39 +117,39 @@
 %install
 # jars
 install -d -m 755 %{buildroot}%{_javadir}
-install -m 644 %{oldname}%{version}-SNAPSHOT/%{oldname}-%{version}-SNAPSHOT.jar %{buildroot}%{_javadir}/%{oldname}.jar
+install -m 644 %{oldname}%{version}-SNAPSHOT/%{oldname}-%{version}-SNAPSHOT.jar %{buildroot}%{_javadir}/%{name}.jar
 # Many packages still use the junit4.jar directly
-ln -s %{_javadir}/%{oldname}.jar %{buildroot}%{_javadir}/%{oldname}4.jar
+ln -s %{_javadir}/%{name}.jar %{buildroot}%{_javadir}/%{oldname}.jar
 
 # pom
 install -d -m 755 %{buildroot}%{_mavenpomdir}
-install -m 644 pom.xml %{buildroot}%{_mavenpomdir}/JPP-%{oldname}.pom
-%add_maven_depmap
+install -m 644 pom.xml %{buildroot}%{_mavenpomdir}/JPP-%{name}.pom
+%add_maven_depmap JPP-%{name}.pom %{name}.jar
 
 # javadoc
-install -d -m 755 %{buildroot}%{_javadocdir}/%{oldname}
-cp -pr %{oldname}%{version}-SNAPSHOT/javadoc/* %{buildroot}%{_javadocdir}/%{oldname}
+install -d -m 755 %{buildroot}%{_javadocdir}/%{name}
+cp -pr %{oldname}%{version}-SNAPSHOT/javadoc/* %{buildroot}%{_javadocdir}/%{name}
 
 # demo
-install -d -m 755 %{buildroot}%{_datadir}/%{oldname}/demo/%{oldname} 
+install -d -m 755 %{buildroot}%{_datadir}/%{name}/demo/%{name} 
 
-cp -pr %{oldname}%{version}-SNAPSHOT/%{oldname}/* %{buildroot}%{_datadir}/%{oldname}/demo/%{oldname}
+cp -pr %{oldname}%{version}-SNAPSHOT/%{oldname}/* %{buildroot}%{_datadir}/%{name}/demo/%{name}
 
 
 %files
 %doc LICENSE README CODING_STYLE
+%{_javadir}/%{name}.jar
 %{_javadir}/%{oldname}.jar
-%{_javadir}/%{oldname}4.jar
 %{_mavenpomdir}/*
 %{_mavendepmapfragdir}/*
 
 %files demo
 %doc LICENSE
-%{_datadir}/%{oldname}
+%{_datadir}/%{name}
 
 %files javadoc
 %doc LICENSE
-%doc %{_javadocdir}/%{oldname}
+%doc %{_javadocdir}/%{name}
 
 %files manual
 %doc LICENSE README CODING_STYLE
!);

    $spec->get_section('description','manual')->push_body('
%package -n junit-junit4
Group:          Development/Java
Summary:        %{oldname} provider
BuildArch: noarch
Requires: %name = %epoch:%{version}-%{release}
Provides: junit = 0:%{version}
Provides: junit = %{epoch}:%{version}-%{release}
Conflicts: junit < 1:3.8.2-alt8
Obsoletes: junit < 1:3.8.2-alt8

#Provides: %_javadir/junit.jar

%description -n junit-junit4
Virtual junit package based on %{name}.

');
    $spec->get_section('files','manual')->push_body('
%files -n junit-junit4
%_altdir/%{name}
');
    $spec->get_section('install')->push_body('
mkdir -p %buildroot%_altdir
cat >>%buildroot%_altdir/%{name}<<EOF
%{_javadir}/junit.jar	%{_javadir}/%{name}.jar	4110
EOF
');

};

__END__
