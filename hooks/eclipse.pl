#!/usr/bin/perl -w

# (3.5.1; TODO: check 3.5.2) does we need it?
#libgnomeui-2.so.0()(64bit) is needed by eclipse-swt-3.5.1-alt2_28jpp6


push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;

    $apprelease=$jpp->get_section('package','')->get_tag('Release');
    $apprelease=$1 if $apprelease=~/_(\d+)jpp/;

    # TODO: check 3.5.2
    # hack -- unmet osgi dependency (recommends?)
    $jpp->get_section('package','platform')->unshift_body('Provides: osgi(org.eclipse.equinox.simpleconfigurator.manipulator) = 1.0.100'."\n");

    # hack until gtk-update-icon-cache fix
    $jpp->del_section('post','platform');
    $jpp->del_section('postun','platform');

    # TODO: remove bootstrap
    if (1) { # bootstrap
	$jpp->get_section('package','')->subst('global bootstrap 0','global bootstrap 1');
	$jpp->get_section('package','')->unshift_body('BuildRequires: jakarta-commons-el jakarta-commons-logging jakarta-commons-codec jakarta-commons-httpclient lucene lucene-contrib icu4j-eclipse jsch objectweb-asm sat4j
BuildRequires: tomcat6-servlet-2.5-api jetty6-core tomcat5-jsp-2.0-api ant-optional
#BuildRequires: junit >= 3.8.1
#BuildRequires: junit4
#BuildRequires: hamcrest >= 0:1.1-9.2

'."\n");
    }


    $jpp->get_section('package','')->unshift_body('Requires: dbus'."\n");
    # it does work...
    $jpp->get_section('package','')->unshift_body('BuildRequires: java-devel-openjdk'."\n");

    #[exec] os.h:83:34: error: X11/extensions/XTest.h: No such file or directory
    # X11/extensions/XInput.h
    #$jpp->get_section('package','')->unshift_body('BuildRequires: xorg-xextproto-devel xorg-inputproto-devel'."\n");
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

# TODO: is it valid for 3.5.1?
# eclipse-pde quick hack against osgi provides
#+ Требует: osgi(Cloudscape)
#+ Требует: osgi(org.apache.derby)
#+ Требует: osgi(org.apache.derby.core)
#    $jpp->get_section('package','pde')->unshift_body('Provides: osgi(Cloudscape) osgi(org.apache.derby) osgi(org.apache.derby.core)'."\n");
    
#    # misplaced in requires
#    $jpp->get_section('package','')->unshift_body('
## todo: remove this 
##add_findreq_skiplist /usr/share/eclipse/plugins/org.eclipse.tomcat_*.v20070531/lib/jspapi.jar
##add_findreq_skiplist %_libdir/eclipse/swt-gtk-3.3.0.jar
#');

    # hack around #22839: built-in /usr/lib*/eclipse
    #$jpp->add_patch('eclipse-3.5.1-alt-syspath-hack.patch', STRIP => 0);

    # it is split from eclipse-launcher-set-install-dir-and-shared-config.patch;
    # no need to apply it: our build of eclipse 3.3.2 seems to be rather stable
    # $jpp->add_patch('eclipse-3.3.2-alt-build-with-debuginfo.patch', STRIP => 0);

    # tomcat5 jasper.jar; note: pure tomcat5-jasper can be used
    $jpp->get_section('package','')->unshift_body('BuildRequires: tomcat5-jasper-eclipse'."\n");

    # around jetty (after 3.3.0-7)
    $jpp->get_section('package','')->subst(qr'BuildRequires:\s+jetty','#BuildRequires: jetty6');
    $jpp->get_section('package','platform')->subst(qr'Requires:\s+jetty','#Requires: jetty6');

    $jpp->get_section('prep')->push_body('sed -i -e s,/jetty,/jetty6,g ./dependencies.properties'."\n");
    $jpp->get_section('prep')->push_body('sed -i -e s,lucene-contrib/lucene-analyzers.jar,lucene-contrib/analyzers.jar,g ./dependencies.properties'."\n");
    $jpp->applied_block(
	"around jetty",
	sub {
    map {$_->subst('%{_javadir}/jetty/jetty','%{_javadir}/jetty6/jetty6')} 
    $jpp->get_section('prep'), 
    $jpp->get_section('build'), 
    $jpp->get_section('install');
	});
    # end around jetty 

    # TODO: upstream it.
    # fixed linkage order with --as-needed
    # todo: REMOVED
    # $jpp->add_patch('eclipse-3.5.1-alt-gtk-as-needed.patch');
    # patch was generated with
    0 && $jpp->get_section('prep')->push_body(q{
## /usr/lib/jvm/java/jre/bin/java: symbol lookup error: /usr/lib64/eclipse/configuration/org.eclipse.osgi/bundles/140/1/.cp/libswt-atk-gtk-3346.so: undefined symbol: atk_object_ref_relation_set
#        $(CC) $(LIBS) $(GNOMELIBS) -o $(GNOME_LIB) $(GNOME_OBJECTS)
find ./plugins -name 'make_linux.mak' -exec perl -i -npe 'chomp;$_=$1.$3.$2 if /^(\s+\$\(CC\))((?: \$\(.*LIBS\))+)(.+)$/;$_.="\n"' {} \;
});

    if (1) {############## TODO: MAKE THEM PATCHES AND CONTRIBUTE #############################
    $jpp->get_section('prep')->push_body(q{
#uname -p == unknown but exit code is 0 :( (alt feature :( )
# seems to be fixed upstream.
#find . -name build.sh -exec sed -i 's,uname -p,uname -m,' {} \;

# TODO: TODO: TODO: TODO: TODO: TODO: TODO: TODO:  DO WE NEED IT WOW?
# due to our xulrunner
# proper patching will touch patches/eclipse-swt-buildagainstxulrunner.patch
# find . -name build.sh -exec sed -i 's,libxul-unstable,libxul,' {} \;

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
    $jpp->get_section('package','platform')->subst(qr'Requires: tomcat5-jasper-eclipse >= 5.5.26-1.5','Requires: tomcat5-jasper-eclipse >= 5.5.26-alt1_1.1jpp');

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

    &replace_built_in_ant($jpp);
    #&leave_built_in_lucene($jpp);
    # TODO: make the transition after 3.4.1 switch!
    #&leave_built_in_icu4j($jpp);
    #&leave_built_in_jetty($jpp);

    # let them be noarches - sorry, not in 3.4.x
    #$jpp->get_section('package','jdt')->push_body("BuildArch: noarch\n");
};

sub replace_built_in_ant {
    my $jpp=shift;
    # ALT ant has extra packages, so enable them
    #################### ANT ####################
    $jpp->get_section('package','')->unshift_body_before('BuildRequires: ant-jai ant-jmf'."\n", qr!BuildRequires: ant-!);
    $jpp->get_section('package','platform')->push_body('Requires: ant-jai ant-jmf'."\n");
    $jpp->get_section('prep')->subst_if(qr'#ln -s %{_javadir}/ant/ant-','ln -s %{_javadir}/ant/ant-',qr'ant-(?:apache-bsf|commons-net|jai|jmf).jar');
    $jpp->get_section('install')->subst_if(qr'#ln -s %{_javadir}/ant/ant-','ln -s %{_javadir}/ant/ant-',qr'ant-(?:apache-bsf|commons-net|jai|jmf).jar');
    ################ END ANT ####################
}


__END__

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
