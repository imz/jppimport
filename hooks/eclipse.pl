#!/usr/bin/perl -w

# (3.5.1; TODO: check 3.5.2) does we need it?
#libgnomeui-2.so.0()(64bit) is needed by eclipse-swt-3.5.1-alt2_28jpp6

# TODO: update lpg when updating eclipse-cdt from 14

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;

    $apprelease=$jpp->get_section('package','')->get_tag('Release');
    $apprelease=$1 if $apprelease=~/_(\d+)jpp/;

    # TODO: upstream it.
    # missing symbol (underlinkage)
    $jpp->add_patch('eclipse-3.6.1-alt-swt-linux-as-needed.patch', STRIP=>0);

    # hack until gtk-update-icon-cache fix
    $jpp->del_section('post','platform');
    $jpp->del_section('postun','platform');

    # ant-bcel,... is missing in BR :(
    $jpp->get_section('package','')->unshift_body('BuildRequires: ant-optional'."\n");

    $jpp->get_section('package','')->unshift_body('Requires: dbus'."\n");
    # it does work...
    $jpp->get_section('package','')->unshift_body('BuildRequires: java-devel-openjdk'."\n");

    # https://bugzilla.altlinux.org/show_bug.cgi?id=23263
    $jpp->get_section('package','swt')->subst_if(qr'xulrunner','xulrunner-libs', qr'Requires:');

    #[exec] os.h:83:34: error: X11/extensions/XTest.h: No such file or directory
    # X11/extensions/XInput.h
    #$jpp->get_section('package','')->unshift_body('BuildRequires: xorg-inputproto-devel xorg-xextproto-devel'."\n");
#xorg-dmxproto-devel xorg-dri2proto-devel xorg-kbproto-devel xorg-renderproto-devel xorg-videoproto-devel xorg-xf86dgaproto-devel xorg-xf86vidmodeproto-devel xorg-xineramaproto-devel xorg-fontcacheproto-devel xorg-glproto-devel xorg-bigreqsproto-devel xorg-compositeproto-devel xorg-damageproto-devel xorg-evieproto-devel xorg-fixesproto-devel xorg-fontsproto-devel xorg-pmproto-devel xorg-printproto-devel xorg-proto-devel xorg-randrproto-devel xorg-recordproto-devel xorg-resourceproto-devel xorg-scrnsaverproto-devel xorg-trapproto-devel xorg-xcbproto-devel xorg-xcmiscproto-devel xorg-xf86bigfontproto-devel xorg-xf86driproto-devel xorg-xf86miscproto-devel xorg-xf86rushproto-devel xorg-xproto-devel

    # I was lazy to search for the whole list of xorg-*proto-devel :(
    $jpp->get_section('package','')->unshift_body('BuildRequires: xorg-devel'."\n");

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
    }

    # lucene
    $jpp->get_section('prep')->push_body('sed -i -e s,lucene-contrib/lucene-analyzers.jar,lucene-contrib/analyzers.jar,g ./dependencies.properties'."\n");


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

