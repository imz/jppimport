#!/usr/bin/perl -w

# done
#require 'set_with_cor eonly.pl';
#require 'set_with_basiconly.pl';
require 'set_jboss_ant18.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    #if require 'set_with_basiconly.pl';=> then we need to add 
    #$jpp->get_section('package','')->unshift_body('BuildRequires: spring jakarta-commons-discovery myfaces-core11-impl javassist'."\n");
    $jpp->get_section('package','')->unshift_body('BuildRequires: jbossretro spring-all'."\n");

    $jpp->add_patch('jboss-4.0.3SP1-alt-ant17support.patch');

    # otherwise Depends: /lib/lsb/init-functions but it is not installable
    $jpp->copy_to_sources('jboss4.init');

    $jpp->get_section('package','')->subst_if(qr'classpathx-mail-monolithic', 'classpathx-mail', qr'Requires:');

    # this hack is due to the bug in blackdown
    # we build with 5.0 but pretend to build with 1.4 (as there are errors)
    $jpp->add_patch('jboss4-4.0.3.1-alt-force-jdk14-only.patch');

    # out of memory errors
    $jpp->get_section('build')->subst(qr'-Xmx128','-Xmx512');
    $jpp->get_section('build')->subst(qr'-Xmx256','-Xmx512');

    # writable files in /usr: not good, rather bug to report
    #$jpp->disable_package('-n jboss4-testsuite');
    # temporary hack
    $jpp->get_section('files','-n jboss4-testsuite')->subst(qr'775,jboss4','755,jboss4');


    ######### TMP hacks for jboss4 4.0.4 (also patch below) ###########
	$jpp->applied_block(
	"jbossws hook",
	    sub {
		foreach my $section ($jpp->get_sections()) {
		    if ($section->get_type() eq 'package') {
			$section->subst(qr'^BuildRequires: jbossws','#BuildRequires: jbossws');
			$section->subst(qr'^Requires: jbossws','#Requires: jbossws');
			
			$section->subst_if(qr'jfreechart','jfreechart0',qr'Requires:');
		    }
		}
	    }
	    );

#jfreechart -> jfreechart0
#otherwise
#/usr/src/RPM/BUILD/jboss-4.0.4.GA-src/console/src/main/org/jboss/console/manager/interfaces/impl/GraphMBeanAttributeAction.java:55: org.jboss.console.manager.interfaces.impl.GraphMBeanAttributeAction.MBeanXYDataset is not abstract and does not override abstract method getSeriesKey(int) in org.jfree.data.general.AbstractSeriesDataset
#   public class MBeanXYDataset extends AbstractXYDataset

    $jpp->get_section('prep')->subst(qr'build-classpath jfreechart\) .','build-classpath jfreechart0) jfreechart.jar');
    $jpp->get_section('install')->subst(qr'jfreechart','jfreechart0');

    $jpp->get_section('prep')->subst(qr'^#mv jbossws-client.jar.no jbossws-client.jar','mv jbossws-client.jar.no jbossws-client.jar');
    $jpp->get_section('prep')->subst(qr'ln -sf \$\(build-classpath jbossws/jbossws-client','#ln -sf $(build-classpath jbossws/jbossws-client');
    $jpp->get_section('prep')->subst(qr'^#mv jbossws14-client.jar.no jbossws14-client.jar','mv jbossws14-client.jar.no jbossws14-client.jar');
    $jpp->get_section('prep')->subst(qr'ln -sf \$\(build-classpath jbossws/jbossws14-client','#ln -sf $(build-classpath jbossws/jbossws14-client');
    $jpp->get_section('install')->subst(qr'rm -f jbossws14','#rm -f jbossws14');
    $jpp->get_section('install')->subst(qr'ln -sf \$\(build-classpath jbossws/jbossws14','#ln -sf $(build-classpath jbossws/jbossws14');
    $jpp->get_section('install')->subst(qr'ln -sf \%{_datadir}/jbossws/jbossws.war','#ln -sf %{_datadir}/jbossws/jbossws.war');

    # broken symlinks
    $jpp->get_section('prep')->subst(qr'ln -sf \$\(build-classpath jboss-microcontainer','ln -sf $(build-classpath jboss-microcontainer/jboss-microcontainer');
    $jpp->get_section('install')->subst(qr'ln -sf \$\(build-classpath jboss-microcontainer','ln -sf $(build-classpath jboss-microcontainer/jboss-microcontainer');

    # TODO due to expansion to dir
    #s|$(build-classpath jboss4/jboss-aspect-library)|/usr/share/java/jboss4/jboss-aspect-library.jar|


    $jpp->get_section('prep')->subst(qr'ln -sf \$\(build-classpath jboss-aop/jrockit-pluggable-instrumentor','#ln -sf $(build-classpath jboss-aop/jrockit-pluggable-instrumentor');

    ###################################################

    # TODO: add
    #s,classpathx-jaf,sun-jaf,g
}

__END__
#cannot find symbol  : class ClassPoolFactory location: package org.jboss.aop
#import org.jboss.aop.ClassPoolFactory;
--- jboss4.spec.0	2009-08-31 06:55:46 +0000
+++ jboss4.spec	2009-08-31 17:36:56 +0000
@@ -147,7 +147,7 @@
 Requires: jaxen
 Requires: jboss4-common = 0:%{version}-%{release}
 Requires: jboss4-connector = 0:%{version}-%{release}
-Requires: jboss4-default = 0:%{version}-%{release}
+Requires: jboss4-config-default = 0:%{version}-%{release}
 Requires: jboss4-deployment = 0:%{version}-%{release}
 Requires: jboss4-iiop = 0:%{version}-%{release}
 Requires: jboss4-jmx = 0:%{version}-%{release}
@@ -329,7 +329,7 @@
 %package        config-all
 Summary:        All configuration for %{name}
 Group:          Development/Java
-Provides:       %{name}-all
+Provides:       %{name}-all 
 Obsoletes:      %{name}-all
 Requires: ant
 Requires: antlr
@@ -383,7 +383,7 @@
 Requires: jboss-microcontainer
 Requires: jboss4-naming = 0:%{version}-%{release}
 Requires: jboss-remoting >= 0:1.4.3
-Requires: jboss4-remoting = 0:%{version}-%{release}
+Requires: jboss4-remoting-int = 0:%{version}-%{release}
 Requires: jboss4-security = 0:%{version}-%{release}
 Requires: jboss-serialization
 Requires: jboss4-server = 0:%{version}-%{release}
@@ -472,7 +472,7 @@
 Requires: jboss-microcontainer
 Requires: jboss4-naming = 0:%{version}-%{release}
 Requires: jboss-remoting
-Requires: jboss4-remoting = 0:%{version}-%{release}
+Requires: jboss4-remoting-int = 0:%{version}-%{release}
 Requires: jboss4-security = 0:%{version}-%{release}
 Requires: jboss-serialization
 Requires: jboss4-server = 0:%{version}-%{release}
@@ -1156,7 +1156,7 @@
 %package        testsuite
 Summary:        Testsuite for %{name}
 Group:          Development/Java
-Requires: jboss4-all = 0:%{version}-%{release}
+Requires: jboss4-config-all = 0:%{version}-%{release}
 
 %description    testsuite
 %{summary}.
@@ -1530,13 +1530,14 @@
 #jboss/aop/lib/jrockit-pluggable-instrumentor.jar.no
 #jboss/aop/lib/pluggable-instrumentor.jar.no
 pushd jboss/aop/lib
-ln -sf $(build-classpath jboss-aop/jboss-aop) .
-ln -sf $(build-classpath jboss-aop/jdk14-pluggable-instrumentor) .
-#
-ln -sf $(build-classpath jboss-aop/jboss-aop-jdk50) .
-ln -sf $(build-classpath jboss-aop/jboss-aop-jdk50-client) .
-#ln -sf $(build-classpath jboss-aop/jrockit-pluggable-instrumentor) .
-ln -sf $(build-classpath jboss-aop/pluggable-instrumentor) .
+#ln -sf $(build-classpath jboss-aop/jboss-aop) .
+#ln -sf $(build-classpath jboss-aop/jdk14-pluggable-instrumentor) .
+##
+#ln -sf $(build-classpath jboss-aop/jboss-aop-jdk50) .
+#ln -sf $(build-classpath jboss-aop/jboss-aop-jdk50-client) .
+##ln -sf $(build-classpath jboss-aop/jrockit-pluggable-instrumentor) .
+#ln -sf $(build-classpath jboss-aop/pluggable-instrumentor) .
+for i in *.no; do mv $i `echo $i| sed -e 's,.no,,'`; done
 popd
 #jboss/microcontainer/lib/jboss-container.jar.no
 #jboss/microcontainer/lib/jboss-dependency.jar.no
@@ -1550,7 +1551,7 @@
 #jfreechart/lib/jfreechart.jar.no
 pushd jfreechart/lib
 ln -sf $(build-classpath jcommon) .
-ln -sf $(build-classpath jfreechart0) .
+ln -sf $(build-classpath jfreechart0) jfreechart.jar
 popd
 #jgroups/lib/jgroups.jar.no
 pushd jgroups/lib
@@ -1570,8 +1571,10 @@
 popd
 #qdox/lib/qdox.jar.no
 pushd qdox/lib
-ln -sf $(build-classpath qdox) .
+#ln -sf $(build-classpath qdox) .
 popd
+# move to the end
+mv qdox/lib/qdox.jar.no qdox/lib/qdox.jar
 #sleepycat/lib/je.jar.no
 pushd sleepycat/lib
 ln -sf $(build-classpath berkeleydb) je.jar
@@ -1982,9 +1985,9 @@
 # install aspects
 install -m 644 aspects/output/lib/jboss-aspect-library32.jar $RPM_BUILD_ROOT%{_javadir}/%{name}/jboss-aspect-library32-%{version}.jar
 install -m 644 aspects/output/lib/jboss-aspect-library.jar $RPM_BUILD_ROOT%{_javadir}/%{name}/jboss-aspect-library-%{version}.jar
-install -m 644 aspects/output/lib/jboss-aspect-jdk50-client.jar $RPM_BUILD_ROOT%{_javadir}/%{name}/jboss-aspect-jdk50-client-%{version}.jar
-install -m 644 aspects/output/lib/jboss-aspect-library-jdk50.jar $RPM_BUILD_ROOT%{_javadir}/%{name}/jboss-aspect-library-jdk50-%{version}.jar
-install -m 644 aspects/output/lib/jboss-aspect-library-jdk50-jb32.jar $RPM_BUILD_ROOT%{_javadir}/%{name}/jboss-aspect-library-jdk50-jb32-%{version}.jar
+#install -m 644 aspects/output/lib/jboss-aspect-jdk50-client.jar $RPM_BUILD_ROOT%{_javadir}/%{name}/jboss-aspect-jdk50-client-%{version}.jar
+#install -m 644 aspects/output/lib/jboss-aspect-library-jdk50.jar $RPM_BUILD_ROOT%{_javadir}/%{name}/jboss-aspect-library-jdk50-%{version}.jar
+#install -m 644 aspects/output/lib/jboss-aspect-library-jdk50-jb32.jar $RPM_BUILD_ROOT%{_javadir}/%{name}/jboss-aspect-library-jdk50-jb32-%{version}.jar
 %endif
 %endif
 
@@ -2054,6 +2057,7 @@
 %if %{without_coreonly}
 %if %{without_basiconly}
 %if %{with_hibernate}
+%if 0
 # install ejb3
 install -m 644 ejb3/output/lib/hibernate-client.jar $RPM_BUILD_ROOT%{_javadir}/%{name}/hibernate-client-%{version}.jar
 install -m 644 ejb3/output/lib/jboss-annotations-ejb3.jar $RPM_BUILD_ROOT%{_javadir}/%{name}/jboss-annotations-ejb3-%{version}.jar
@@ -2062,16 +2066,19 @@
 %endif
 %endif
 %endif
+%endif
 
 # ejb3x/output/lib/jboss-ejb3x.jar
 %if %{without_coreonly}
 %if %{without_basiconly}
 %if %{with_hibernate}
+%if 0
 # install ejb3x
 install -m 644 ejb3x/output/lib/jboss-ejb3x.jar $RPM_BUILD_ROOT%{_javadir}/%{name}/jboss-ejb3x-%{version}.jar
 %endif
 %endif
 %endif
+%endif
 
 %if %{without_coreonly}
 %if %{without_basiconly}
@@ -2193,7 +2200,7 @@
 %if %{with_hibernate}
 # install spring-int
 install -m 644 spring-int/output/lib/jboss-spring.jar $RPM_BUILD_ROOT%{_javadir}/%{name}/jboss-spring-%{version}.jar
-install -m 644 spring-int/output/lib/jboss-spring-jdk5.jar $RPM_BUILD_ROOT%{_javadir}/%{name}/jboss-spring-jdk5-%{version}.jar
+#install -m 644 spring-int/output/lib/jboss-spring-jdk5.jar $RPM_BUILD_ROOT%{_javadir}/%{name}/jboss-spring-jdk5-%{version}.jar
 %endif
 %endif
 %endif
@@ -2524,8 +2531,8 @@
 ln -sf %{_javadir}/%{name}/jboss-srp-client.jar
 rm -f jboss-system-client.jar
 ln -sf %{_javadir}/%{name}/jboss-system-client.jar
-rm -f jbossws14-client.jar
-ln -sf %{_javadir}/jbossws/jbossws14-client.jar
+#rm -f jbossws14-client.jar
+#ln -sf %{_javadir}/jbossws/jbossws14-client.jar
 rm -f jboss-xml-binding.jar
 ln -sf %{_javadir}/%{name}/jboss-xml-binding.jar
 rm -f jboss-transaction-client.jar
@@ -2795,7 +2802,7 @@
 rm -f jboss-aop.jar
 ln -sf $(build-classpath jboss-aop/jboss-aop)
 rm -f jboss-aspect-library.jar
-ln -sf $(build-classpath jboss4/jboss-aspect-library)
+ln -sf /usr/share/java/jboss4/jboss-aspect-library.jar
 popd
 
 pushd $RPM_BUILD_ROOT%{jbossdir}/server/all/deploy/jboss-bean.deployer
@@ -2806,7 +2813,7 @@
 rm jboss-bean-deployer.jar
 ln -sf %{_javadir}/%{name}/jboss-bean-deployer.jar
 rm jboss-microcontainer.jar
-ln -sf $(build-classpath jboss-microcontainer) .
+ln -sf $(build-classpath jboss-microcontainer/jboss-microcontainer) .
 popd
 
 pushd $RPM_BUILD_ROOT%{jbossdir}/server/all/deploy/jbossweb-tomcat55.sar
@@ -2935,7 +2942,7 @@
 rm -f jboss-aop.jar
 ln -sf $(build-classpath jboss-aop/jboss-aop) .
 rm -f jboss-aspect-library.jar
-ln -sf $(build-classpath jboss4/jboss-aspect-library) .
+ln -sf /usr/share/java/jboss4/jboss-aspect-library.jar .
 popd
 
 pushd $RPM_BUILD_ROOT%{jbossdir}/server/default/deploy/jboss-bean.deployer
@@ -2946,7 +2953,7 @@
 rm -f jboss-bean-deployer.jar
 ln -sf %{_javadir}/%{name}/jboss-bean-deployer.jar
 rm -f jboss-microcontainer.jar
-ln -sf $(build-classpath jboss-microcontainer)
+ln -sf $(build-classpath jboss-microcontainer/jboss-microcontainer)
 popd
 
 pushd $RPM_BUILD_ROOT%{jbossdir}/server/default/deploy/jbossweb-tomcat55.sar
@@ -3338,12 +3345,12 @@
 %{_javadir}/%{name}/jboss-aspect-library32.jar
 %{_javadir}/%{name}/jboss-aspect-library-%{version}.jar
 %{_javadir}/%{name}/jboss-aspect-library.jar
-%{_javadir}/%{name}/jboss-aspect-jdk50-client-%{version}.jar
-%{_javadir}/%{name}/jboss-aspect-jdk50-client.jar
-%{_javadir}/%{name}/jboss-aspect-library-jdk50-%{version}.jar
-%{_javadir}/%{name}/jboss-aspect-library-jdk50.jar
-%{_javadir}/%{name}/jboss-aspect-library-jdk50-jb32-%{version}.jar
-%{_javadir}/%{name}/jboss-aspect-library-jdk50-jb32.jar
+#%{_javadir}/%{name}/jboss-aspect-jdk50-client-%{version}.jar
+#%{_javadir}/%{name}/jboss-aspect-jdk50-client.jar
+#%{_javadir}/%{name}/jboss-aspect-library-jdk50-%{version}.jar
+#%{_javadir}/%{name}/jboss-aspect-library-jdk50.jar
+#%{_javadir}/%{name}/jboss-aspect-library-jdk50-jb32-%{version}.jar
+#%{_javadir}/%{name}/jboss-aspect-library-jdk50-jb32.jar
 %endif
 %endif
 
@@ -3442,6 +3449,7 @@
 %if %{without_coreonly}
 %if %{without_basiconly}
 %if %{with_hibernate}
+%if 0
 %files ejb3
 %{_javadir}/%{name}/hibernate-client-%{version}.jar
 %{_javadir}/%{name}/jboss-annotations-ejb3-%{version}.jar
@@ -3454,16 +3462,19 @@
 %endif
 %endif
 %endif
+%endif
 
 %if %{without_coreonly}
 %if %{without_basiconly}
 %if %{with_hibernate}
+%if 0
 %files ejb3x
 %{_javadir}/%{name}/jboss-ejb3x-%{version}.jar
 %{_javadir}/%{name}/jboss-ejb3x.jar
 %endif
 %endif
 %endif
+%endif
 
 %if %{without_coreonly}
 %if %{without_basiconly}
@@ -3626,8 +3637,8 @@
 %files spring-int
 %{_javadir}/%{name}/jboss-spring-%{version}.jar
 %{_javadir}/%{name}/jboss-spring.jar
-%{_javadir}/%{name}/jboss-spring-jdk5-%{version}.jar
-%{_javadir}/%{name}/jboss-spring-jdk5.jar
+#%{_javadir}/%{name}/jboss-spring-jdk5-%{version}.jar
+#%{_javadir}/%{name}/jboss-spring-jdk5.jar
 %endif
 %endif
 %endif
