#!/usr/bin/perl -w

require 'add_missingok_config.pl';
require 'set_bin_755.pl';

push @SPECHOOKS, 
 sub {
    my ($jpp, $alt) = @_;
    &add_missingok_config($jpp, '/etc/java/aspectj.conf','');
    #$jpp->add_patch('aspectj-ant_0_8_fix.diff',STRIP=>2);
    $jpp->get_section('package','')->subst_if('saxon(\s+[>=]+\s+[\d:\-\.]+)?','saxon6',qr'Requires:');
    $jpp->get_section('prep')->subst(qr'build-classpath saxon','build-classpath saxon6');

    # for 1.5.4. Deprecated?
    $jpp->get_section('package','')->unshift_body('BuildRequires: ant-apache-regexp ant-apache-xalan2'."\n");
    # ant 1.8
    $jpp->get_section('prep')->push_body(q!sed -i -e 's,<antcall,<antcall inheritRefs="true",g'  build/build-properties.xml!."\n");
    $jpp->get_section('build')->subst(qr'-Xmx512','-Xmx1024');
    $jpp->get_section('install')->subst(qr'\%{buildroot}\%{_libdir}/eclipse','%{buildroot}%{_datadir}/eclipse');
    $jpp->get_section('files','eclipse-plugins')->subst(qr'\%{_libdir}/eclipse','%{_datadir}/eclipse');
}
__END__
#    $jpp->get_section('package')->subst('saxon-scripts','saxon6-scripts');
#    $jpp->applied_block(
#    	"bin saxon6 hook",
#	sub {
#    $jpp->get_section('build')->subst('/usr/bin/saxon','/usr/bin/saxon6');
#    $jpp->get_section('prep')->subst('/usr/bin/saxon','/usr/bin/saxon6');
#    $jpp->get_section('build')->subst('saxon\s+-o','saxon6 -o');
#    $jpp->get_section('prep')->subst('saxon\s+-o','saxon6 -o');
#    });
--- aspectj.spec	2012-10-12 22:25:36.000000000 +0300
+++ aspectj.spec	2012-10-13 12:12:10.000000000 +0300
@@ -1,3 +1,4 @@
+%def_with modified_bcel_rebuild
 # BEGIN SourceDeps(oneline):
 BuildRequires: python-devel unzip
 # END SourceDeps(oneline)
@@ -59,6 +60,10 @@
 Source12:       http://repo1.maven.org/maven2/org/aspectj/aspectjtools/%{version}/aspectjtools-%{version}.pom
 Source13:       http://repo1.maven.org/maven2/org/aspectj/aspectjweaver/%{version}/aspectjweaver-%{version}.pom
 
+%if_with modified_bcel_rebuild
+Source99: patch.txt
+%endif
+
 BuildRequires:  jpackage-utils >= 0:1.7.5
 BuildRequires:  junit
 BuildRequires:  ant >= 0:1.7.1
@@ -162,6 +167,18 @@
 #sed -i -e 's,classpathref=,classpath refid=,g'  build/build-properties.xml
 sed -i -e 's,<antcall,<antcall inheritRefs="true",g'  build/build-properties.xml
 
+%if_with modified_bcel_rebuild
+# bcel-builder fixes
+sed -i -e 's,source="1\.4",source="1.5",' bcel-builder/build-bcel.xml
+sed -i -e 's,"diff\.exe","diff",' bcel-builder/build.xml
+cp -a %{SOURCE99} bcel-builder/patch.txt
+%else
+pushd lib/bcel/
+mv bcel-verifier.jar.no bcel-verifier.jar
+mv bcel.jar.no bcel.jar
+popd
+%endif
+
 %build
 #export JAVA_HOME=%{java_home}
 export ANT_OPTS="-Xmx1024M"
@@ -170,6 +187,7 @@
 ant \
 ant-launcher \
 commons-logging \
+objectweb-asm/asm \
 )
 
 # now for eclipse 3.6.X
@@ -187,12 +205,16 @@
 CLASSPATH=${CLASSPATH}:$(ls %{_libdir}/eclipse/plugins/org.eclipse.equinox.app_*.jar)
 CLASSPATH=${CLASSPATH}:$(ls %{_libdir}/eclipse/plugins/org.eclipse.core.runtime_*.jar)
 
+%if_with modified_bcel_rebuild
 pushd bcel-builder
-%{ant} -v -Dant.build.javac.source=1.5 -Dant.build.javac.target=1.5  -f build-bcel.xml
+%{ant} -v -Dant.build.javac.source=1.5 -Dant.build.javac.target=1.5 -f build-bcel.xml
 cp bin/bcel.jar .
+cp ../lib/bcel/bcel-verifier.jar.no bcel-verifier.jar
+mv ../lib/bcel/bcel-verifier-src.zip .
 %{ant} -Dant.build.javac.source=1.5 -Dant.build.javac.target=1.5  extractAndPatchAndJar
 %{ant} -Dant.build.javac.source=1.5 -Dant.build.javac.target=1.5  push
 popd
+%endif
 
 # rebuild jdtcore-for-aspectj.jar from sources
 pushd org.eclipse.jdt.core
@@ -209,12 +231,16 @@
 touch build/local.properties
 %{ant} -Dant.build.javac.source=1.5 -Dant.build.javac.target=1.5  -Dbuild.sysclasspath=first
 
+pushd org.aspectj.lib
+%{ant} -Dant.build.javac.source=1.5 -Dant.build.javac.target=1.5  -Dbuild.sysclasspath=first -f build-aspectjlib.xml 
+popd
+
 %install
 # jars, poms, depmap frags
 install -d -m 0755 %{buildroot}%{_javadir}
 install -d -m 0755 %{buildroot}%{_datadir}/maven2/poms
 
-install -m 0644 aj-build/dist/tools/lib/aspectjlib.jar \
+install -m 0644 org.aspectj.lib/jars/aspectjlib.out.jar \
         %{buildroot}%{_javadir}/%{name}lib-%{version}.jar
 install -m 0644 %{SOURCE10} %{buildroot}%{_datadir}/maven2/poms/JPP-aspectjlib.pom
 %add_to_maven_depmap org.aspectj aspectjlib %{version} JPP %{name}lib
