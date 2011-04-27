#!/usr/bin/perl -w

# (3.5.1; TODO: check 3.5.2) does we need it?
#libgnomeui-2.so.0()(64bit) is needed by eclipse-swt-3.5.1-alt2_28jpp6

# TODO: update lpg when updating eclipse-cdt from 14

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;

    $apprelease=$jpp->get_section('package','')->get_tag('Release');
    $apprelease=$1 if $apprelease=~/_(\d+)jpp/;

    # upstreamed as https://bugs.eclipse.org/bugs/show_bug.cgi?id=338360
    # missing symbol (underlinkage)
    $jpp->add_patch('eclipse-3.6.2-alt-libgnomeproxy-gcc-as-needed.patch', STRIP=>0);
    # just -lX11 added
    $jpp->add_patch('eclipse-3.6.2-alt-swt-linux-as-needed.patch', STRIP=>0);

    # hack until gtk-update-icon-cache fix
    #$jpp->del_section('post','platform');
    #$jpp->del_section('postun','platform');

    # ant-bcel,... is missing in BR :(
    $jpp->get_section('package','')->unshift_body('BuildRequires: ant-optional'."\n");

    $jpp->get_section('package','')->unshift_body('Requires: dbus'."\n");
    # it does work...
    $jpp->get_section('package','')->unshift_body('BuildRequires: java-devel-openjdk'."\n");

    # https://bugzilla.altlinux.org/show_bug.cgi?id=23263
    $jpp->get_section('package','swt')->subst_if(qr'xulrunner','xulrunner-libs', qr'Requires:');

    $jpp->get_section('package','')->unshift_body('BuildRequires: xorg-proto-devel libGLU-devel'."\n");
    $jpp->get_section('package','')->subst_if(qr'libmesa-devel','libGLU-devel', qr'Requires:');

    # or rm %buildroot%_libdir/eclipse/plugins/org.apache.ant_*/bin/runant.py
    $jpp->get_section('package','')->unshift_body('AutoReqProv: yes,nopython'."\n");
    $jpp->get_section('package','platform')->unshift_body('AutoReqProv: yes,nopython'."\n");

    $jpp->get_section('package','')->unshift_body('BuildRequires: java-javadoc'."\n");
    $jpp->get_section('package','')->unshift_body('%define _enable_debug 1'."\n");

    # seamonkey provides mozilla too
    $jpp->get_section('package','swt')->subst(qr'Conflicts:\s*mozilla','Conflicts:     mozilla < 1.8');

# add this to debug org.eclipse.equinox.p2
#-nosplash -debug -consoleLog --launcher.suppressErrors

    # it is split from eclipse-launcher-set-install-dir-and-shared-config.patch;
    # no need to apply it: our build of eclipse 3.3.2 seems to be rather stable
    # $jpp->add_patch('eclipse-3.3.2-alt-build-with-debuginfo.patch', STRIP => 0);

    if (0) {
	# around jetty (after 3.3.0-7)
	$jpp->get_section('package','')->subst(qr'BuildRequires:\s+jetty','BuildRequires: jetty6-core');
	$jpp->get_section('package','platform')->subst(qr'Requires:\s+jetty','Requires: jetty6-core');
	
	$jpp->get_section('prep')->push_body('sed -i -e s,/jetty,/jetty6,g ./dependencies.properties'."\n");
	# end around jetty 
    } else {
	# embed jetty and apply the patch below
	$jpp->get_section('package','')->subst(qr'BuildRequires:\s+jetty','#BuildRequires: jetty6-core');
	$jpp->get_section('package','platform')->subst(qr'Requires:\s+jetty','#Requires: jetty6-core');
    }

    # lucene
    $jpp->get_section('prep')->push_body('sed -i -e s,lucene-contrib/lucene-analyzers.jar,lucene-contrib/analyzers.jar,g ./dependencies.properties'."\n");
    $jpp->get_section('install')->subst('lucene-contrib/lucene-analyzers.jar','lucene-contrib/analyzers.jar');


    if (1) {############## TODO: MAKE THEM PATCHES AND CONTRIBUTE #############################
    $jpp->get_section('prep')->push_body(q{
#uname -p == unknown but exit code is 0 :( (alt feature :( )
# seems to be fixed upstream.
#find . -name build.sh -exec sed -i 's,uname -p,uname -m,' {} \;

# TODO: TODO: TODO: TODO: TODO: TODO: TODO: TODO:  DO WE NEED IT WOW?
# due to our xulrunner
# proper patching will touch patches/eclipse-swt-buildagainstxulrunner.patch
find . -name build.sh -exec sed -i 's,libxul-unstable,libxul,' {} \;

});
    }################################################### end TODO MAKE AS PATCHES


    if ('build' eq 'use openjdk instead of default') {
	$jpp->get_section('package','')->subst(qr'jpackage-1.?-compat','jpackage-generic-compat');
	$jpp->get_section('package','')->unshift_body('BuildRequires: java-1.6.0-openjdk-devel');
    } 

    # hack around added in -15 exact versions
    $jpp->get_section('package','')->subst_if(qr'-\d+jpp(?:\.\d+)?','', qr'^BuildRequires:');
    $jpp->get_section('package','platform')->subst(qr'Requires: jakarta-commons-el >= 1.0-9','Requires: jakarta-commons-el >= 1.0-alt3');
    $jpp->get_section('package','platform')->subst(qr'Requires: jakarta-commons-logging >= 1.0.4-6jpp.3','Requires: jakarta-commons-logging >= 1.1-alt2_3jpp1.7');
    $jpp->get_section('package','platform')->subst(qr'Requires: tomcat5-jasper-eclipse >= 5.5.27-6.3','Requires: tomcat5-jasper-eclipse >= 5.5.27');

    if (0) {
    #support for alt feature
    $jpp->copy_to_sources('org.altlinux.ide.feature-1.0.0.zip');
    $jpp->copy_to_sources('org.altlinux.ide.platform-3.4.1.zip');
    $jpp->applied_block(
	"support for alt feature",
	sub {
	    foreach my $section ($jpp->get_sections()) {
		$section->subst(qr'org.fedoraproject','org.altlinux');
		$section->subst(qr'Fedora Eclipse','ALT Linux Eclipse');
	    }
	});
    $jpp->get_section('prep')->push_body(q!subst s,org.fedoraproject,org.altlinux, %{SOURCE28}
!);
    }


    $jpp->get_section('install')->push_body(q!# check for undefined symbols
if find %buildroot%_libdir/eclipse -type f -name '*.so' -print0 \
 | xargs -0 ldd -r 2>&1 \
 | grep -v SUNWprivate \
 | grep 'undefined symbol'; then
    echo "JPP robo-check for undefined symbols failed."
    exit 1;
fi
!);

#warning: file /usr/lib64/eclipse/configuration/org.eclipse.osgi/bundles/111/1/.cp/libswt-atk-gtk-3557.so is packaged into both eclipse-swt and eclipse-rcp
    $jpp->get_section('files','rcp')->push_body(q!# duplicates of swt
%exclude %_libdir/eclipse/configuration/org.eclipse.osgi/bundles/*/*/.cp/libswt-*.so
!);

};


__END__
    # TODO: remove bootstrap
    if (0) { # bootstrap
	$jpp->get_section('package','')->subst('global bootstrap 0','global bootstrap 1');
	$jpp->get_section('package','')->unshift_body('BuildRequires: jakarta-commons-el jakarta-commons-logging jakarta-commons-codec jakarta-commons-httpclient lucene lucene-contrib icu4j-eclipse jsch objectweb-asm sat4j
BuildRequires: tomcat6-servlet-2.5-api jetty6-core tomcat5-jsp-2.0-api tomcat5-jasper-eclipse ant-optional
'."\n");
    }

    $jpp->get_section('prep')->push_body(q{
%if 0
# if enable make_xpcominit ...
subst 's!all $MAKE_GNOME $MAKE_CAIRO $MAKE_AWT $MAKE_MOZILLA!all $MAKE_GNOME $MAKE_CAIRO $MAKE_AWT $MAKE_MOZILLA make_xpcominit!' './plugins/org.eclipse.swt/Eclipse SWT PI/gtk/library/build.sh'
subst s,XULRUNNER_INCLUDES,MOZILLA_INCLUDES, './plugins/org.eclipse.swt/Eclipse SWT PI/gtk/library/make_linux.mak'
# was used for build with firefox
#subst 's,${XULRUNNER_LIBS},%_libdir/firefox/libxpcomglue.a,' './plugins/org.eclipse.swt/Eclipse SWT PI/gtk/library/make_linux.mak'
# used for build with xulrunner
subst 's,${XULRUNNER_LIBS},%_libdir/xulrunner-devel/sdk/lib/libxpcomglue.a,' './plugins/org.eclipse.swt/Eclipse SWT PI/gtk/library/make_linux.mak'
%endif

# if disable awt
# subst 's!all $MAKE_GNOME $MAKE_CAIRO $MAKE_AWT $MAKE_MOZILLA!all $MAKE_GNOME $MAKE_CAIRO $MAKE_MOZILLA!' './plugins/org.eclipse.swt/Eclipse SWT PI/gtk/library/build.sh'
});
    }################################################### end TODO MAKE AS PATCHES

    # hack around #22839: built-in /usr/lib*/eclipse
    # $jpp->add_patch('eclipse-3.5.1-alt-syspath-hack.patch', STRIP => 0);

### jetty embedding patch for eclipse-3.6.1 (just apply as it is ;)
--- eclipse.spec	2011-02-27 22:26:07 +0200
+++ eclipse.spec	2011-02-27 23:33:22 +0200
@@ -50,6 +50,9 @@
 Source19:       %{name}-filenamepatterns.txt
 # This script copies the platform sub-set of the SDK for generating metadata
 Source28:       %{name}-mv-Platform.sh
+Source33: jetty-6.1.24.jar 
+Source34: jetty-util-6.1.24.jar 
+
 
 # Make sure the shipped target platform templates are looking in the
 # correct location for source bundles (see RHBZ # 521969). This does not
@@ -260,6 +263,8 @@
 popd
 %patch33 -p0
 sed -i -e s,lucene-contrib/lucene-analyzers.jar,lucene-contrib/analyzers.jar,g ./dependencies.properties
+sed -i -e s,/usr/share/java/jetty/jetty.jar,%{SOURCE33},g dependencies.properties
+sed -i -e s,/usr/share/java/jetty/jetty-util.jar,%{SOURCE34},g dependencies.properties
 
 #uname -p == unknown but exit code is 0 :( (alt feature :( )
 # seems to be fixed upstream.
@@ -630,13 +635,13 @@
 ln -s %{_javadir}/hamcrest/core.jar \
   dropins/jdt/plugins/org.hamcrest.core_$HAMCRESTCOREVERSION
 
-JETTYPLUGINVERSION=$(ls plugins | grep org.mortbay.jetty.server_6 | sed 's/org.mortbay.jetty.server_//')
-rm plugins/org.mortbay.jetty.server_$JETTYPLUGINVERSION
-ln -s %{_javadir}/jetty/jetty.jar plugins/org.mortbay.jetty.server_$JETTYPLUGINVERSION
-
-JETTYUTILVERSION=$(ls plugins | grep org.mortbay.jetty.util_6 | sed 's/org.mortbay.jetty.util_//')
-rm plugins/org.mortbay.jetty.util_$JETTYUTILVERSION
-ln -s %{_javadir}/jetty/jetty-util.jar plugins/org.mortbay.jetty.util_$JETTYUTILVERSION
+#JETTYPLUGINVERSION=$(ls plugins | grep org.mortbay.jetty.server_6 | sed 's/org.mortbay.jetty.server_//')
+#rm plugins/org.mortbay.jetty.server_$JETTYPLUGINVERSION
+#ln -s %{_javadir}/jetty/jetty.jar plugins/org.mortbay.jetty.server_$JETTYPLUGINVERSION
+
+#JETTYUTILVERSION=$(ls plugins | grep org.mortbay.jetty.util_6 | sed 's/org.mortbay.jetty.util_//')
+#rm plugins/org.mortbay.jetty.util_$JETTYUTILVERSION
+#ln -s %{_javadir}/jetty/jetty-util.jar plugins/org.mortbay.jetty.util_$JETTYUTILVERSION
 
 JSCHVERSION=$(ls plugins | grep com.jcraft.jsch_ | sed 's/com.jcraft.jsch_//')
 rm plugins/com.jcraft.jsch_$JSCHVERSION
