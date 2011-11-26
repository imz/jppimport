#!/usr/bin/perl -w

require 'set_bin_755.pl';

push @PREHOOKS, sub {
    my ($jpp, $parent) = @_;
    # TODO: think how we can have clean uninstall
    {
	my $comment=0;
	my $preunsec=$jpp->get_section('preun','platform');
	# comment because it hangs on rpm -qf "$file" :(
	$preunsec->map_body(sub {
	    $comment=1 if /Delete orphaned profile files/;
	    $_='#'.$_ if $comment;
	    $comment=0 if $comment==1 and /^#done/;
							});
	$jpp->get_section('postun','platform')->push_body(q!if [ "$1" = 0 ]; then
    # Delete orphaned profile files (less efficient than variant above :(
    rm -rf %{_libdir}/%{name}/p2/org.eclipse.equinox.p2.engine/profileRegistry/PlatformProfile.profile
fi
!);
    }
};

push @SPECHOOKS, 
sub {
    my ($jpp, $parent) = @_;

    $apprelease=$jpp->get_section('package','')->get_tag('Release');
    $apprelease=$1 if $apprelease=~/_(\d+)jpp/;

    $jpp->get_section('build')->unshift_body(q!export CXX='g++ -Dchar16_t="unsigned short int"'!."\n");

    # as-needed specific
    $jpp->add_patch('eclipse-3.7.0-alt-as-needed-statically-link-xpcomglue.patch', STRIP=>2,
		    PREP_HEADER=>'pushd build/eclipse-%version-*'."\n");
    # upstreamed as https://bugs.eclipse.org/bugs/show_bug.cgi?id=338360
    # missing symbol (underlinkage)
    $jpp->add_patch('eclipse-3.7.0-alt-libgnomeproxy-gcc-as-needed.patch', STRIP=>2);
    # just -lX11 added
    $jpp->add_patch('eclipse-3.7.0-alt-swt-linux-as-needed.patch', STRIP=>2,
		    PREP_FOOTER=>'popd'."\n");

    # eclipse-rcp-3.6.2...: unpackaged directory: /usr/...
    # sisyphus_check: check-subdirs ERROR: subdirectories packaging violation
    $jpp->get_section('files','rcp')->push_body('%dir %_libdir/eclipse/configuration/org.eclipse.osgi'."\n");

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
    #$jpp->get_section('package','')->subst_if(qr'libmesa-devel','libGLU-devel', qr'Requires:');

    # or rm %buildroot%_libdir/eclipse/plugins/org.apache.ant_*/bin/runant.py
    $jpp->get_section('package','')->unshift_body('AutoReqProv: yes,nopython'."\n");
    $jpp->get_section('package','platform')->unshift_body('AutoReqProv: yes,nopython'."\n");

    $jpp->get_section('package','')->unshift_body('BuildRequires: java-javadoc'."\n");
    $jpp->get_section('package','')->unshift_body('%define _enable_debug 1'."\n");

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
	$jpp->add_source('jetty-6.1.26.jar', NUMBER => 33);
	$jpp->add_source('jetty-util-6.1.26.jar', NUMBER => 34);
	$jpp->get_section('prep')->push_body('
sed -i -e s,/usr/share/java/jetty/jetty.jar,%{SOURCE33},g dependencies.properties
sed -i -e s,/usr/share/java/jetty/jetty-util.jar,%{SOURCE34},g dependencies.properties
#sed -i -e s,/usr/share/jetty/lib/jetty-6.1.26.jar,%{SOURCE33},g `grep -rl /usr/share/jetty/lib/jetty-6.1.26.jar .`
#sed -i -e s,/usr/share/jetty/lib/jetty-util-6.1.26.jar,%{SOURCE34},g `grep -rl /usr/share/jetty/lib/jetty-util-6.1.26.jar .`
'."\n");
	$jpp->get_section('install')->push_body('
jetty=`ls %buildroot%_libdir/eclipse/plugins/org.mortbay.jetty.util*`
rm -f $jetty
install -m 644 %{SOURCE34} $jetty
jetty=`ls %buildroot%_libdir/eclipse/plugins/org.mortbay.jetty.server*`
rm -f $jetty
install -m 644 %{SOURCE33} $jetty
');
    }

q!
     [exec] Model is x86_64
     [exec] libgnome-2.0 and libgnomeui-2.0 not found:
     [exec]     *** SWT Program support for GNOME will not be compiled.
     [exec] Cairo found, compiling SWT support for the cairo graphics library.
     [exec] WebKit not found:
     [exec]     *** WebKit embedding support will not be compiled.
     [exec] libjawt.so found, the SWT/AWT integration library will be compiled.
     [exec] Building SWT/GTK+ for linux x86_64
!;

    if (0) {############## TODO: MAKE THEM PATCHES AND CONTRIBUTE #############################
    $jpp->get_section('prep')->push_body(q{
#uname -p == unknown but exit code is 0 :( (alt feature :( )
# seems to be fixed upstream.
find . -name build.sh -exec sed -i 's,uname -p,uname -m,' {} \;
});
    }################################################### end TODO MAKE AS PATCHES


    if ('build' eq 'use openjdk instead of default') {
	$jpp->get_section('package','')->subst(qr'jpackage-1.?-compat','jpackage-generic-compat');
	$jpp->get_section('package','')->unshift_body('BuildRequires: java-1.6.0-openjdk-devel');
    } 

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

    # reconsiler filetrigger.
    # two platform sections :(
    #$jpp->get_section('files','platform')->push_body('/usr/lib/rpm/%{name}-%{_arch}.filetrigger'."\n");
    foreach my $section ($jpp->get_sections()) {
	next unless $section->get_type eq 'files' and $section->get_package eq 'platform';
	next if $section->get_flag('-f');
	$section->push_body('/usr/lib/rpm/%{name}-%{_arch}.filetrigger'."\n");
    }
    $jpp->get_section('install')->push_body(q@# reconsiler filetrigger
mkdir -p %buildroot/usr/lib/rpm
cat > %buildroot/usr/lib/rpm/%{name}-%{_arch}.filetrigger << 'EOF'
#!/bin/sh -e
egrep -qs '^%{_libdir}/eclipse' && [ -x /usr/bin/eclipse-reconciler.sh ] && /usr/bin/eclipse-reconciler.sh %{_libdir}/eclipse /var/tmp > /dev/null ||:
EOF
chmod 755 %buildroot/usr/lib/rpm/%{name}-%{_arch}.filetrigger
echo /usr/lib/rpm/%{name}-%{_arch}.filetrigger >> %{name}-platform.install
@);

};


__END__



    # seamonkey provides mozilla too
    #$jpp->get_section('package','swt')->subst(qr'Conflicts:\s*mozilla','Conflicts:     mozilla < 1.8');

    # lucene
    #$jpp->get_section('prep')->push_body('sed -i -e s,lucene-contrib/lucene-analyzers.jar,lucene-contrib/analyzers.jar,g ./dependencies.properties'."\n");
    #$jpp->get_section('install')->subst('lucene-contrib/lucene-analyzers.jar','lucene-contrib/analyzers.jar');




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
    # hack around added in -15 exact versions

    $jpp->get_section('package','')->subst_if(qr'-\d+jpp(?:\.\d+)?','', qr'^BuildRequires:');
    $jpp->get_section('package','platform')->subst(qr'Requires: jakarta-commons-el >= 1.0-9','Requires: jakarta-commons-el >= 1.0-alt3');
    $jpp->get_section('package','platform')->subst(qr'Requires: jakarta-commons-logging >= 1.0.4-6jpp.3','Requires: jakarta-commons-logging >= 1.1-alt2_3jpp1.7');
    $jpp->get_section('package','platform')->subst(qr'Requires: tomcat5-jasper-eclipse >= 5.5.27-6.3','Requires: tomcat5-jasper-eclipse >= 5.5.27');
