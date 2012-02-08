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
!."\n");
    $jpp->disable_package('grizzly');
    $jpp->disable_package('jboss');
    $jpp->disable_package('wadi');
    $jpp->disable_package('cometd');
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
