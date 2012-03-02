#!/usr/bin/perl -w

require 'set_fix_homedir_macro.pl';
require 'add_missingok_config.pl';
require 'set_add_fc_osgi_manifest.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;

    $jpp->main_section->subst('bcond_without cometd','bcond_with cometd');
    $jpp->main_section->subst('bcond_without wadi','bcond_with wadi');
    # till cometd will be updated
$jpp->get_section('prep')->push_body(q!
 sed -i -e '/<module>contrib\/jboss<\/module>/d' pom.xml
 sed -i -e '/<module>contrib\/cometd<\/module>/d' pom.xml
 sed -i -e '/<module>contrib\/grizzly<\/module>/d' pom.xml
 sed -i -e '/<module>contrib\/wadi<\/module>/d' pom.xml
 sed -i -e '/<module>contrib\/terracotta<\/module>/d' pom.xml
!."\n");
    $jpp->disable_package('grizzly');
    $jpp->disable_package('jboss');
    $jpp->disable_package('wadi');
    $jpp->disable_package('cometd');
    $jpp->disable_package('terracotta');
    $jpp->get_section('package','webapps')->exclude(qr'^Requires:.*-cometd');

    #%define appdir /srv/jetty6
    $jpp->get_section('package','')->subst_if(qr'/srv/jetty6', '/var/lib/jetty6',qr'\%define');

    # not tested
    #$jpp->get_section('package','')->unshift_body(q!BuildRequires: jetty6-core!."\n");

    # requires from nanocontainer-webcontainer :(
    #$jpp->get_section('package','jsp-2.0')->push_body('Provides: jetty6-jsp-2.0-api = %version'."\n");

    &add_missingok_config($jpp, '/etc/default/%{name}','');
    &add_missingok_config($jpp, '/etc/default/jetty','');

    $jpp->copy_to_sources('jetty.init');
    #if ($jpp->get_section('package','')->match_body(qr'Source7:\s+jetty.init\s*$')) {
    #	$jpp->get_section('prep')->push_body("sed -i 's,daemon --user,start_daemon --user,' %SOURCE7"."\n");
    #}
    $jpp->applied_block(
	"exclude tempdir hook",
	sub {
	    foreach my $section ($jpp->get_sections()) {
		$section->exclude(qr'\%{tempdir}');
	    }
	}
	);

    # remove explicit group ids
    $jpp->get_section('pre','')->subst(qr'-[gu]\s+%\{jtuid\}','-r');
    # set default shell to /dev/null (will it work ?)
    #$jpp->get_section('pre','')->subst(qr'-s /bin/sh','/dev/null');
    # hack to fix upgrade from -alt2 if rmuser/adduser to be applied
    #$jpp->get_section('post','')->push_body('chown -R %{name}.%{name} %logdir'."\n");

    $jpp->spec_apply_patch(PATCHSTRING=>q!
--- jetty6.spec	2012-02-08 13:41:09.699875117 +0000
+++ jetty6.spec	2012-02-08 13:43:57.107874173 +0000
@@ -887,10 +887,12 @@
 popd
 # ================= End of Jetty Maven2-Plugin subpackages install
 
+%if_with grizzly
 # ================= Start of Jetty-Grizzly subpackage install
 install -d -m 755 %{buildroot}%{_javadir}/%{name}/grizzly
 install -m 644 contrib/grizzly/target/jetty-grizzly-%{version}.jar %{buildroot}%{_javadir}/%{name}/grizzly/%{name}-grizzly-%{version}.jar
 # ================= End of Jetty-Grizzly subpackage install
+%endif
 
 # ================= Start of Jetty-J2se6 subpackage install
 install -d -m 755 %{buildroot}%{_javadir}/%{name}/j2se6
@@ -988,7 +988,9 @@
 install -m 644 etc/jetty.xml %{buildroot}%{confdir}/jetty.xml
 install -m 644 etc/jetty-ajp.xml %{buildroot}%{confdir}/jetty-ajp.xml
 install -m 644 etc/jetty-bio.xml %{buildroot}%{confdir}/jetty-bio.xml
+%if_with grizzly
 install -m 644 etc/jetty-grizzly.xml %{buildroot}%{confdir}/jetty-grizzly.xml
+%endif
 install -m 644 etc/jetty-jmx.xml %{buildroot}%{confdir}/jetty-jmx.xml
 install -m 644 etc/jetty-logging.xml %{buildroot}%{confdir}/jetty-logging.xml
 %if %with plus
@@ -1038,11 +1040,13 @@
     fi
 done
 
+%if_with jboss
 # ================= Start of Jetty-JBoss subpackage install
 %{__install} -d -m 0755 %{buildroot}%{_datadir}/%{name}
 %{__install} -m 0644 contrib/jboss/target/jetty-%{version}-jboss-4.2.3.GA-jsp-2.1.jboss-sar \
 			%{buildroot}%{_datadir}/%{name}/jetty-%{version}-jboss4-jsp-2.1.sar
 # ================= End of Jetty-JBoss subpackage install
+%endif
 
 # ================= Start of Jetty-Webapps subpackage install
 LOC=$(pwd)
@@ -1084,6 +1086,7 @@
 popd
 
 mkdir -p %{buildroot}%{appdir}/cometd
+%if_with cometd
 pushd %{buildroot}%{appdir}/cometd
 jar xf ${LOC}/contrib/cometd/demo/target/cometd-demo-%{version}.war
 popd
@@ -1097,6 +1100,7 @@
 ln -s %{_javadir}/jetty6/jetty6-util.jar %{buildroot}%{appdir}/cometd/WEB-INF/lib/
 rm %{buildroot}%{appdir}/cometd/WEB-INF/lib/servlet-api-2.5.jar
 ln -s %{_javadir}/servlet_2_5_api.jar %{buildroot}%{appdir}/cometd/WEB-INF/lib/
+%endif
 
 install -m 644 contexts/README-test-jndi.txt \
      %{buildroot}%{ctxdir}
@@ -1108,10 +1112,14 @@
      %{buildroot}%{ctxdir}
 install -m 644 contexts/test.xml \
      %{buildroot}%{ctxdir}
+%if_with wadi
 install -m 644 contexts/wadi.xml \
      %{buildroot}%{ctxdir}
+%endif
+%if_with cometd
 install -m 644 contrib/cometd/demo/etc/cometd.xml \
      %{buildroot}%{ctxdir}
+%endif
 
 # ================= End of Jetty-Webapps subpackage install
!);


}



__END__
--- jetty6.spec.0	2012-02-26 16:16:14.000000000 +0000
+++ jetty6.spec	2012-02-26 16:53:11.541296288 +0000
@@ -603,6 +607,8 @@
 cp -p %{SOURCE10} ${MAVEN_REPO_LOCAL}/org/eclipse/jetty/jetty-parent/14/jetty-parent-14.pom
 mkdir -p ${MAVEN_REPO_LOCAL}/org/mortbay/jetty/jetty-parent/8
 cp -p %{SOURCE11} ${MAVEN_REPO_LOCAL}/org/mortbay/jetty/jetty-parent/8/jetty-parent-8.pom
+mkdir -p ${MAVEN_REPO_LOCAL}/org/mortbay/jetty/jetty-parent/9
+cp -p %{SOURCE9} ${MAVEN_REPO_LOCAL}/org/mortbay/jetty/jetty-parent/9/jetty-parent-9.pom
 mkdir -p $MAVEN_REPO_LOCAL/org/hyperic/libsigar-x86-linux/1.6.4/
 if [ -e %{_libdir}/libsigar-x86-linux.so ]; then 
    ln -s %{_libdir}/libsigar-x86-linux.so $MAVEN_REPO_LOCAL/org/hyperic/libsigar-x86-linux/1.6.4/libsigar-x86-linux-1.6.4.so
@@ -930,10 +936,12 @@
 install -m 644 contrib/sweeper/target/sweeper-%{version}.jar %{buildroot}%{_javadir}/%{name}/sweeper/%{name}-sweeper-%{version}.jar
 # ================= End of Jetty-Sweeper subpackage install
 
+%if_with terracotta
 # ================= Start of Jetty-Terracotta subpackage install
 install -d -m 755 %{buildroot}%{_javadir}/%{name}/terracotta
 install -m 644 contrib/terracotta/target/jetty-terracotta-sessions-%{version}.jar %{buildroot}%{_javadir}/%{name}/terracotta/%{name}-terracotta-sessions-%{version}.jar
 # ================= End of Jetty-Terracotta subpackage install
+%endif
 
 # ================= Start of Jetty-Extratests subpackage install
 install -d -m 755 %{buildroot}%{_javadir}/%{name}/extratests
@@ -1255,8 +1263,10 @@
 %add_to_maven_depmap org.mortbay.jetty jetty-sweeper %{version} JPP/%{name}/sweeper %{name}-sweeper
 install -m 644 contrib/sweeper/pom.xml %{buildroot}%{_datadir}/maven2/poms/JPP.jetty6.sweeper-%{name}-sweeper.pom
 
+%if_with terracotta
 %add_to_maven_depmap org.mortbay.jetty jetty-terracotta-sessions %{version} JPP/%{name}/terracotta %{name}-terracotta-sessions
 install -m 644 contrib/terracotta/pom.xml %{buildroot}%{_datadir}/maven2/poms/JPP.jetty6.terracotta-%{name}-terracotta-sessions.pom
+%endif
 
 %add_to_maven_depmap org.mortbay.jetty jetty-util5 %{version} JPP/%{name}/jre1.5 %{name}-util5
 install -m 644 modules/util5/pom.xml %{buildroot}%{_datadir}/maven2/poms/JPP.jetty6.jre1.5-%{name}-util5.pom
@@ -1619,6 +1629,7 @@
 %doc LICENSES/LICENSE*.txt
 # ========= End of Jetty sweeper  Subpackage Files
 
+%if_with terracotta
 # ========= Start of Jetty terracotta Subpackage Files
 %files -n %{jettyname}6-terracotta
 %dir %{_javadir}/%{name}/terracotta
@@ -1629,6 +1640,7 @@
 %doc *.txt
 %doc LICENSES/LICENSE*.txt
 # ========= End of Jetty terracotta  Subpackage Files
+%endif
 
 # ========= Start of Jetty util5 Subpackage Files
 %files -n %{jettyname}6-util5


--- ../SOURCES/jetty-parent-14.pom.0	2011-07-19 09:04:30.000000000 +0000
+++ ../SOURCES/jetty-parent-14.pom	2012-02-26 16:30:33.640029913 +0000
@@ -266,7 +266,6 @@
             <requireJavaVersion>
               <version>[1.5,)</version>
             </requireJavaVersion>
-            <versionRule implementation="org.eclipse.jetty.toolchain.enforcer.rules.VersionRule" />
           </rules>
         </configuration>         
         <version>1.0-alpha-4</version>
@@ -278,13 +277,6 @@
             </goals>       
           </execution>
         </executions>
-        <dependencies>
-           <dependency>
-             <groupId>org.eclipse.jetty.toolchain</groupId>
-             <artifactId>jetty-enforcer-rules</artifactId>
-             <version>1.0</version>
-           </dependency>
-        </dependencies>
       </plugin>
       <plugin>
         <groupId>org.apache.maven.plugins</groupId>
