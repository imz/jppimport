#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
# bugfix; to be commited in bugzilla
    $jpp->get_section('install')->subst(qr'ln -s %{name}-resolver-12-%{version}','ln -s %{name}-resolver12-%{version}');

    # alt sppecific - removed ghosted alternatives symlink
    $jpp->get_section('install')->subst(qr'ln -s %\{_sysconfdir\}/alternatives/%\{name\}-apis-javadoc \$RPM_BUILD_ROOT%\{_javadocdir\}/%\{name\}-apis # ghost symlink','#ln -s %{_sysconfdir}/alternatives/%{name}-apis-javadoc $RPM_BUILD_ROOT%{_javadocdir}/%{name}-apis # ghost symlink');
    $jpp->get_section('files','jaxp-1.3-apis-javadoc')->subst(qr'%ghost %\{_javadocdir\}/\%\{name\}-apis','#%ghost %{_javadocdir}/%{name}-apis');
    $jpp->get_section('files','jaxp-1.2-apis-javadoc')->subst(qr'%ghost %\{_javadocdir\}/\%\{name\}-apis','#%ghost %{_javadocdir}/%{name}-apis');
    $jpp->get_section('files','jaxp-1.1-apis-javadoc')->subst(qr'%ghost %\{_javadocdir\}/\%\{name\}-apis','#%ghost %{_javadocdir}/%{name}-apis');
}

__END__
patch to be applied to spec:
--- xml-commons.spec	2007-09-27 00:01:09 +0300
+++ xml-commons.spec	2007-04-18 16:45:42 +0300
@@ -649,21 +645,21 @@
 EOF
 install -d $RPM_BUILD_ROOT/%_altdir; cat >$RPM_BUILD_ROOT/%_altdir/xml-resolver_%{name}-resolver10<<EOF
 %{_bindir}/xml-resolver	%{_bindir}/xml-resolver10	10000
-%{_javadir}/xml-commons-resolver10.jar	%{_javadir}/xml-commons-resolver.jar	%{_bindir}/xml-resolver10
-%{_bindir}/xml-xread10	%{_bindir}/xml-xread	%{_bindir}/xml-resolver10
-%{_bindir}/xml-xparse10	%{_bindir}/xml-xparse	%{_bindir}/xml-resolver10
-%{_mandir}/man1/xml-resolver10.1	%{_mandir}/man1/xml-resolver.1	%{_bindir}/xml-resolver10
-%{_mandir}/man1/xml-xread10.1	%{_mandir}/man1/xml-xread.1	%{_bindir}/xml-resolver10
-%{_mandir}/man1/xml-xparse10.1	%{_mandir}/man1/xml-xparse.1	%{_bindir}/xml-resolver10
+%{_javadir}/xml-commons-resolver.jar	%{_javadir}/xml-commons-resolver10.jar	%{_bindir}/xml-resolver10
+%{_bindir}/xml-xread	%{_bindir}/xml-xread10	%{_bindir}/xml-resolver10
+%{_bindir}/xml-xparse	%{_bindir}/xml-xparse10	%{_bindir}/xml-resolver10
+%{_mandir}/man1/xml-resolver.1	%{_mandir}/man1/xml-resolver10.1	%{_bindir}/xml-resolver10
+%{_mandir}/man1/xml-xread.1	%{_mandir}/man1/xml-xread10.1	%{_bindir}/xml-resolver10
+%{_mandir}/man1/xml-xparse.1	%{_mandir}/man1/xml-xparse10.1	%{_bindir}/xml-resolver10
 EOF
 install -d $RPM_BUILD_ROOT/%_altdir; cat >$RPM_BUILD_ROOT/%_altdir/xml-resolver_%{name}-resolver11<<EOF
 %{_bindir}/xml-resolver	%{_bindir}/xml-resolver11	10100
-%{_javadir}/xml-commons-resolver11.jar	%{_javadir}/xml-commons-resolver.jar	%{_bindir}/xml-resolver11
-%{_bindir}/xml-xread11	%{_bindir}/xml-xread	%{_bindir}/xml-resolver11
-%{_bindir}/xml-xparse11	%{_bindir}/xml-xparse	%{_bindir}/xml-resolver11
-%{_mandir}/man1/xml-resolver11.1	%{_mandir}/man1/xml-resolver.1	%{_bindir}/xml-resolver11
-%{_mandir}/man1/xml-xread11.1	%{_mandir}/man1/xml-xread.1	%{_bindir}/xml-resolver11
-%{_mandir}/man1/xml-xparse11.1	%{_mandir}/man1/xml-xparse.1	%{_bindir}/xml-resolver11
+%{_javadir}/xml-commons-resolver.jar	%{_javadir}/xml-commons-resolver11.jar	%{_bindir}/xml-resolver11
+%{_bindir}/xml-xread	%{_bindir}/xml-xread11	%{_bindir}/xml-resolver11
+%{_bindir}/xml-xparse	%{_bindir}/xml-xparse11	%{_bindir}/xml-resolver11
+%{_mandir}/man1/xml-resolver.1	%{_mandir}/man1/xml-resolver11.1	%{_bindir}/xml-resolver11
+%{_mandir}/man1/xml-xread.1	%{_mandir}/man1/xml-xread11.1	%{_bindir}/xml-resolver11
+%{_mandir}/man1/xml-xparse.1	%{_mandir}/man1/xml-xparse11.1	%{_bindir}/xml-resolver11
 EOF
 install -d $RPM_BUILD_ROOT/%_altdir; cat >$RPM_BUILD_ROOT/%_altdir/xml-commons-apis_%{name}-jaxp-1.2-apis<<EOF
 %{_javadir}/xml-commons-apis.jar	%{_javadir}/jaxp12.jar	10200
@@ -718,14 +714,13 @@
 EOF
 install -d $RPM_BUILD_ROOT/%_altdir; cat >$RPM_BUILD_ROOT/%_altdir/xml-resolver_%{name}-resolver12<<EOF
 %{_bindir}/xml-resolver	%{_bindir}/xml-resolver12	10200
-%{_javadir}/xml-commons-resolver12.jar	%{_javadir}/xml-commons-resolver.jar	%{_bindir}/xml-resolver12
-%{_bindir}/xml-xread12	%{_bindir}/xml-xread	%{_bindir}/xml-resolver12
-%{_bindir}/xml-xparse12	%{_bindir}/xml-xparse	%{_bindir}/xml-resolver12
-%{_mandir}/man1/xml-resolver12.1	%{_mandir}/man1/xml-resolver.1	%{_bindir}/xml-resolver12
-%{_mandir}/man1/xml-xread12.1	%{_mandir}/man1/xml-xread.1	%{_bindir}/xml-resolver12
-%{_mandir}/man1/xml-xparse12.1	%{_mandir}/man1/xml-xparse.1	%{_bindir}/xml-resolver12
+%{_javadir}/xml-commons-resolver.jar	%{_javadir}/xml-commons-resolver12.jar	%{_bindir}/xml-resolver12
+%{_bindir}/xml-xread	%{_bindir}/xml-xread12	%{_bindir}/xml-resolver12
+%{_bindir}/xml-xparse	%{_bindir}/xml-xparse12	%{_bindir}/xml-resolver12
+%{_mandir}/man1/xml-resolver.1	%{_mandir}/man1/xml-resolver12.1	%{_bindir}/xml-resolver12
+%{_mandir}/man1/xml-xread.1	%{_mandir}/man1/xml-xread12.1	%{_bindir}/xml-resolver12
+%{_mandir}/man1/xml-xparse.1	%{_mandir}/man1/xml-xparse12.1	%{_bindir}/xml-resolver12
 EOF
-
 %files 
 %doc xml-commons-external-1_3_03/*.txt
 %config(noreplace) %{resolverdir}/*
