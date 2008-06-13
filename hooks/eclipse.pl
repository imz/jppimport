#!/usr/bin/perl -w

require 'set_update_menus.pl';
#require 'set_target_14.pl';
# todo; set jvm 5? does not help?

# does we need it?
#libgnomeui-2.so.0()(64bit)   is needed by libswt3-gtk2-3.3.0-alt1_5jpp1.7

$spechook = sub {
    my ($jpp, $alt) = @_;

    $apprelease=$jpp->get_section('package','')->get_tag('Release');
    $apprelease=$1 if $apprelease=~/_(\d+)jpp/;

    $jpp->get_section('package','')->unshift_body('BuildRequires: tomcat5-servlet-2.4-api tomcat5-jsp-2.0-api tomcat5-jasper'."\n");

    $jpp->get_section('package','')->unshift_body('BuildRequires: java-javadoc'."\n");
    $jpp->get_section('package','')->unshift_body('%define _enable_debug 1'."\n");

    # misplaced in requires
    $jpp->get_section('package','')->unshift_body('
# todo: remove this 
%add_findreq_skiplist /usr/share/eclipse/plugins/org.eclipse.tomcat_*.v20070531/lib/jspapi.jar
%add_findreq_skiplist %_libdir/eclipse/swt-gtk-3.3.0.jar
%add_findreq_skiplist /usr/share/eclipse/plugins/org.junit_3.8.2.v200706111738/junit.jar
');

    # hack around requires in post / postun scripts
    $jpp->get_section('package','rcp')->unshift_body('Provides: %_libdir/eclipse/configuration/config.ini'."\n");

    # hack around requires in spec body (they put it in for biarch reasons
    $jpp->get_section('package','-n libswt3-gtk2')->unshift_body('Provides: %{_libdir}/%{name}/plugins/org.eclipse.swt.gtk.linux.%{eclipse_arch}_3.3.0.v3346.jar'."\n");

    #Epoch:  1
    $jpp->get_section('package','')->subst(qr'Epoch:\s+1', 'Epoch:  0');
    $jpp->get_section('package','ecj')->subst(qr'Obsoletes:\s*ecj', '#Obsoletes:	ecj');
    $jpp->get_section('package','ecj')->subst(qr'Provides:\s*ecj', '#Provides:	ecj');

    # overwrite with fixed versions
    # segfault at start: -- getProgramDir() at eclipse.c(947)
    # due to a bug in %patch12
#diff eclipse-launcher-set-install-dir-and-shared-config.patch{~,}
#39c39
#< +     programDir = malloc( (_tcslen( temp + 1 )) * sizeof(_TCHAR) );
#---
#> +     programDir = malloc( (_tcslen( temp ) + 1) * sizeof(_TCHAR) );
    $jpp->copy_to_sources('eclipse-3.3.0-alt-launcher-set-install-dir-and-shared-config.patch');
    # double free bug still exist
    $jpp->copy_to_sources('eclipse-3.3.0-alt-launcher-double-free-bug.patch');
    $jpp->get_section('package','')->subst(qr'%{name}-launcher-double-free-bug.patch','eclipse-3.3.0-alt-launcher-double-free-bug.patch');
    $jpp->get_section('package','')->subst(qr'%{name}-launcher-set-install-dir-and-shared-config.patch','eclipse-3.3.0-alt-launcher-set-install-dir-and-shared-config.patch');

    # in rel30
    $jpp->get_section('package','')->subst(qr'java-javadoc >= 1.6.0','java-javadoc');
    $jpp->get_section('package','jdt')->subst(qr'java-javadoc >= 1.6.0','java-javadoc');

    # around jetty (after 3.3.0-7)
    $jpp->get_section('package','')->subst(qr'BuildRequires:\s+jetty','BuildRequires: jetty5');
    $jpp->get_section('package','platform')->subst(qr'Requires:\s+jetty','#Requires: jetty5');
    map {$_->subst('%{_javadir}/jetty/jetty.jar','%{_javadir}/jetty5/jetty5.jar')} 
    $jpp->get_section('prep'), 
    $jpp->get_section('build'), 
    $jpp->get_section('install');
    # end around jetty 5

    # multilib_support temporally disabled due to failed build
    $jpp->get_section('package','')->unshift_body('%def_disable multilib_support'."\n");
    $jpp->get_section('install')->unshift_body_before(q{%if_enabled multilib_support
}, qr'# Ensure that the zip files are the same across all builds.');
    $jpp->get_section('install')->unshift_body_after(q{%endif # multilib_support
}, qr'rm -rf \${RPM_BUILD_ROOT}/tmp');

    # they loose JAVA_HOME :(
    $jpp->get_section('prep')->unshift_body_after(q{
find ./features -name build.sh -exec %__subst 's,javaHome="",javaHome="/usr/lib/jvm/java",' {} \;
find ./plugins \( -name build.sh -or -name Makefile \) -exec %__subst 's,JAVA_HOME \?=.*,JAVA_HOME=/usr/lib/jvm/java,' {} \;
}, qr'%setup'); # after because before zip/unzip-ing

    $jpp->get_section('prep')->push_body(q{
find ./features -name build.sh -exec %__subst 's,javaHome="",javaHome="/usr/lib/jvm/java",' {} \;
find ./plugins \( -name build.sh -or -name Makefile \) -exec %__subst 's,JAVA_HOME \?=.*,JAVA_HOME=/usr/lib/jvm/java,' {} \;

#uname -p == unknown but exit code is 0 :( (alt feature :( )
find . -name build.sh -exec %__subst 's,uname -p,uname -m,' {} \;

# SUN JDK support
find ./plugins -name 'make_linux.mak' -exec %__subst 's,/usr/lib/jvm/java/jre/lib/x86_64,/usr/lib/jvm/java/jre/lib/amd64,' {} \;
find ./plugins -name 'make_linux.mak' -exec %__subst 's,/usr/lib/jvm/java/jre/lib/i586,/usr/lib/jvm/java/jre/lib/i386,' {} \;

# fixed linkage order with --as-needed
## /usr/lib/jvm/java/jre/bin/java: symbol lookup error: /usr/lib64/eclipse/configuration/org.eclipse.osgi/bundles/140/1/.cp/libswt-atk-gtk-3346.so: undefined symbol: atk_object_ref_relation_set
#        $(CC) $(LIBS) $(GNOMELIBS) -o $(GNOME_LIB) $(GNOME_OBJECTS)
find ./plugins -name 'make_linux.mak' -exec perl -i -npe 'chomp;$_=$1.$3.$2 if /^(\s+\$\(CC\))((?: \$\(.*LIBS\))+)(.+)$/;$_.="\n"' {} \;

# if enable make_xpcominit ...
subst 's!all $MAKE_GNOME $MAKE_CAIRO $MAKE_AWT $MAKE_MOZILLA!all $MAKE_GNOME $MAKE_CAIRO $MAKE_AWT $MAKE_MOZILLA make_xpcominit!' './plugins/org.eclipse.swt/Eclipse SWT PI/gtk/library/build.sh'
subst s,XULRUNNER_INCLUDES,MOZILLA_INCLUDES, './plugins/org.eclipse.swt/Eclipse SWT PI/gtk/library/make_linux.mak'
subst 's,${XULRUNNER_LIBS},%_libdir/firefox/libxpcomglue.a,' './plugins/org.eclipse.swt/Eclipse SWT PI/gtk/library/make_linux.mak'

# if disable awt
# subst 's!all $MAKE_GNOME $MAKE_CAIRO $MAKE_AWT $MAKE_MOZILLA!all $MAKE_GNOME $MAKE_CAIRO $MAKE_MOZILLA!' './plugins/org.eclipse.swt/Eclipse SWT PI/gtk/library/build.sh'
});

    $jpp->get_section('install')->push_body(q{
# avoid warning -- useless
# shebang.req.files: executable script  not executable
chmod 755 %buildroot/usr/bin/eclipse
# todo: symlink to ant-scripts
#chmod 755 %buildroot/usr/share/eclipse/plugins/org.apache.ant_*/bin/*
chmod 755 %buildroot/usr/share/eclipse/buildscripts/copy-platform
chmod 755 %buildroot/usr/share/eclipse/plugins/org.eclipse.pde.build_*/templates/package-build/prepare-build-dir.sh
});

    # hack around added in -13 Obsoletes in pde
    $jpp->get_section('package','pde')->subst(qr'1:3.3.0-13.fc8','0:3.3.0-alt2_13jpp5.0');

    # hack around added in -13 fix-java-home.patch (we fix it in our subst?)
    $jpp->get_section('prep')->subst(qr'^%patch26','#%patch26');
    $jpp->get_section('prep')->subst_after(qr'^sed --in-place "s/JAVA_HOME','#sed --in-place "s/JAVA_HOME',qr'# liblocalfile fixes');

$jpp->get_section('prep')->push_body_after(
q!
pushd plugins/org.eclipse.swt/Eclipse\ SWT\ PI/gtk/library
# /usr/lib -> /usr/lib64
sed --in-place "s:/usr/lib/:%{_libdir}/:g" build.sh
%ifarch x86_64
sed --in-place "s:-L\$(AWT_LIB_PATH):-L%{_jvmdir}/java/jre/lib/amd64:" make_linux.mak
%endif
%ifarch %ix86
sed --in-place "s:-L\$(AWT_LIB_PATH):-L%{_jvmdir}/java/jre/lib/i386:" make_linux.mak
%endif
popd
!, qr'plugins/org.junit4/junit.jar');

    # added in -14, removed -in -19
    #$jpp->get_section('package','')->subst(qr'Requires: eclipse-rpm-editor','#Requires: eclipse-rpm-editor');

    # present at least in 3.3.0: warning: file /usr/share/eclipse/plugins/org.eclipse.swt_3.3.0.v3346.jar is packaged into both libswt3-gtk2 and eclipse-rcp
    $jpp->get_section('files','rcp')->subst(qr'\%{_datadir}/\%{name}/plugins/org.eclipse.swt_','#%{_datadir}/%{name}/plugins/org.eclipse.swt_');

    # seamonkey provides mozilla
    $jpp->get_section('package','-n %{libname}-gtk2')->subst(qr'Conflicts:\s*mozilla','#Conflicts:     mozilla');

    # hack around added in -15 exact versions
    $jpp->get_section('package','')->subst_if(qr'-\d+jpp(?:\.\d+)?','', qr'^BuildRequires:');
    $jpp->get_section('package','platform')->subst(qr'Requires: jakarta-commons-el >= 1.0-8jpp','Requires: jakarta-commons-el >= 1.0-alt1_8.2jpp1.7');
    $jpp->get_section('package','platform')->subst(qr'Requires: jakarta-commons-logging >= 1.0.4-6jpp.3','Requires: jakarta-commons-logging >= 1.1-alt2_3jpp1.7');
    $jpp->get_section('package','platform')->subst(qr'Requires: tomcat5 >= 5.5.23-9jpp.4','Requires: tomcat5 >= 5.5.25-alt1_1.1jpp');
    $jpp->get_section('package','platform')->subst(qr'Requires: tomcat5-jasper-eclipse >= 5.5.23-9jpp.4','Requires: tomcat5-jasper-eclipse >= 5.5.25-alt1_1.1jpp');
    $jpp->get_section('package','platform')->subst(qr'Requires: tomcat5-servlet-2.4-api >= 5.5.23-9jpp.4','Requires: tomcat5-servlet-2.4-api >= 5.5.25-alt1_1.1jpp');
    $jpp->get_section('package','platform')->subst(qr'Requires: tomcat5-jsp-2.0-api >= 5.5.23-9jpp.4','Requires: tomcat5-jsp-2.0-api >= 5.5.25-alt1_1.1jpp');

# desktop-file-validate /usr/src/RPM/SOURCES/eclipse.desktop
#/usr/src/RPM/SOURCES/eclipse.desktop: error: value "eclipse.png" for key "Icon" in group "Desktop Entry" is an icon name with an extension, but there should be no extension as described in the Icon Theme Specification if the value is not an absolute path
#/usr/src/RPM/SOURCES/eclipse.desktop: warning: key "Encoding" in group "Desktop Entry" is deprecated
#/usr/src/RPM/SOURCES/eclipse.desktop: warning: value "Application;IDE;Development;Java;X-Red-Hat-Base;" for key "Categories" in group "Desktop Entry" contains a deprecated value "Application"
    $jpp->get_section('install')->unshift_body_before(q{%__subst 's,Icon=eclipse.png,Icon=eclipse,' %{SOURCE2}
%__subst 's,Categories=Application;,Categories=,' %{SOURCE2}
%__subst 's,X-Red-Hat-Base;,,' %{SOURCE2}
},qr'desktop-file-validate %{SOURCE2}');

    #support for alt feature
    $jpp->copy_to_sources('org.altlinux.ide.feature-1.0.0.zip');
    $jpp->copy_to_sources('org.altlinux.ide.platform-3.3.0.zip');
    foreach my $section (@{$jpp->get_sections_ref()}) {
	$section->subst(qr'org.fedoraproject','org.altlinux');
    }
    $jpp->get_section('package','')->subst_if(qr'[.-]\d+.zip','.zip',qr'^Source4:');

    &replace_built_in_ant($jpp);
    &leave_built_in_lucene($jpp);
    #&leave_built_in_jasper_plugin($jpp);

#TODO: sed --in-place "s/4.1.130/5.5.23/g" на sed --in-place "s/4.1.230/5.5.25/g"


};

sub replace_built_in_ant {
    my $jpp=shift;
    # ALT ant has extra packages, so enable them
    #################### ANT ####################
    $jpp->get_section('package','')->unshift_body_before('BuildRequires: ant-apache-bsf ant-commons-net ant-jai ant-jmf ant-stylebook', qr!# Fedora.  When that's done, add it here and symlink below.!);
foreach my $antcmt (qr"# Need to investigate why we don't build ant-apache-bsf or ant-commons-net in",
qr"# Fedora.  When that's done, add it here and symlink below.",
qr'# https://bugzilla.redhat.com/bugzilla/show_bug.cgi\?id=180642') {
    $jpp->get_section('package','')->subst($antcmt,'');
    $jpp->get_section('package','platform')->subst($antcmt,'');
}
    $jpp->get_section('package','platform')->subst(qr'^#Requires: ant-apache-bsf ant-commons-net', 
	   'Requires: ant-apache-bsf ant-commons-net ant-jai ant-jmf ant-stylebook');
    $jpp->get_section('prep')->subst_if(qr'#ln -s %{_javadir}/ant/ant-','ln -s %{_javadir}/ant/ant-',qr'ant-(?:apache-bsf|commons-net|jai|jmf|stylebook).jar');
    $jpp->get_section('install')->subst_if(qr'#rm plugins/org.apache.ant_1.7.0.v200706080842','rm plugins/org.apache.ant_1.7.0.v200706080842',qr'ant-(?:apache-bsf|commons-net|jai|jmf|stylebook).jar');
    $jpp->get_section('install')->subst_if(qr'#ln -s %{_javadir}/ant/ant-','ln -s %{_javadir}/ant/ant-',qr'ant-(?:apache-bsf|commons-net|jai|jmf|stylebook).jar');
    ################ END ANT ####################
}


sub leave_built_in_jasper_plugin {
    my $jpp=shift;
    ############### jasper ######################
    # fix for jasper ; looks like it is required for help to work
    #$jpp->get_section('install')->unshift_body_after('ln -s %{_javadir}/tomcat5-jasper-runtime.jar plugins/org.apache.jasper_5.5.17.v200706111724.jar',qr'rm plugins/org.apache.jasper_5.5.17.v200706111724.jar');
    $jpp->get_section('install')->subst(qr'rm plugins/org.apache.jasper_5.5.17.v200706111724.jar', '#rm plugins/org.apache.jasper_5.5.17.v200706111724.jar');
    $jpp->get_section('package','platform')->subst(qr'^Requires: tomcat5-jasper-eclipse', 'Conflicts: tomcat5-jasper-eclipse');

# link to jasper in prep
#rm plugins/org.apache.jasper_5.5.17.v200706111724.jar
#ln -s  %{_datadir}/eclipse/plugins/org.apache.jasper_5.5.17.v200706111724.jar \
#   plugins/org.apache.jasper_5.5.17.v200706111724.jar
    $jpp->get_section('prep')->subst(qr'rm plugins/org.apache.jasper_5.5.17.v200706111724.jar', '#rm plugins/org.apache.jasper_5.5.17.v200706111724.jar');
    $jpp->get_section('prep')->subst(qr'ln -s  %{_datadir}/eclipse/plugins/org.apache.jasper_5.5.17.v200706111724.jar', '#ln -s  %{_datadir}/eclipse/plugins/org.apache.jasper_5.5.17.v200706111724.jar');
    $jpp->get_section('prep')->subst(qr'^\s+plugins/org.apache.jasper_5.5.17.v200706111724.jar', '#   plugins/org.apache.jasper_5.5.17.v200706111724.jar');
    $jpp->get_section('files','platform')->unshift_body('%{_datadir}/%{name}/plugins/org.apache.jasper_5.5.17.*'."\n");
    #############################################
}

sub leave_built_in_lucene {
    my $jpp=shift;
    # lucene: let it leave eclipse version
    $jpp->get_section('package','platform')->subst(qr'^Requires: lucene >= 1.9.1', '#Requires: lucene >= 1.9.1');
    $jpp->get_section('package','platform')->subst(qr'^Requires: lucene-contrib >= 1.9.1', '#Requires: lucene-contrib >= 1.9.1');
    $jpp->get_section('package','')->subst(qr'^BuildRequires: lucene >= 1.9.1', '#BuildRequires: lucene >= 1.9.1');
    $jpp->get_section('package','')->subst(qr'^BuildRequires: lucene-contrib >= 1.9.1', '#BuildRequires: lucene-contrib >= 1.9.1');

    $jpp->get_section('prep')->subst(qr'rm plugins/org.apache.lucene_1.9.1.v200706111724.jar','#rm plugins/org.apache.lucene_1.9.1.v200706111724.jar');
    $jpp->get_section('prep')->subst(qr'ln -s %{_javadir}/lucene.jar plugins/org.apache.lucene_1.9.1.v200706111724.jar','#ln -s %{_javadir}/lucene.jar plugins/org.apache.lucene_1.9.1.v200706111724.jar');
    $jpp->get_section('prep')->subst(qr'rm plugins/org.apache.lucene.analysis_1.9.1.v200706181610.jar','#rm plugins/org.apache.lucene.analysis_1.9.1.v200706181610.jar');
    $jpp->get_section('prep')->subst(qr'ln -s %{_javadir}/lucene-contrib/lucene-analyzers.jar plugins/org.apache.lucene.analysis_1.9.1.v200706181610.jar','#ln -s %{_javadir}/lucene-contrib/lucene-analyzers.jar plugins/org.apache.lucene.analysis_1.9.1.v200706181610.jar');

    $jpp->get_section('install')->subst(qr'rm plugins/org.apache.lucene_1.9.1.v200706111724.jar','#rm plugins/org.apache.lucene_1.9.1.v200706111724.jar');
    $jpp->get_section('install')->subst(qr'ln -s %{_javadir}/lucene.jar plugins/org.apache.lucene_1.9.1.v200706111724.jar','#ln -s %{_javadir}/lucene.jar plugins/org.apache.lucene_1.9.1.v200706111724.jar');
    $jpp->get_section('install')->subst(qr'rm plugins/org.apache.lucene.analysis_1.9.1.v200706181610.jar','#rm plugins/org.apache.lucene.analysis_1.9.1.v200706181610.jar');
    $jpp->get_section('install')->subst(qr'ln -s %{_javadir}/lucene-contrib/lucene-analyzers.jar plugins/org.apache.lucene.analysis_1.9.1.v200706181610.jar','#ln -s %{_javadir}/lucene-contrib/lucene-analyzers.jar plugins/org.apache.lucene.analysis_1.9.1.v200706181610.jar');
    # end lucene
}

__END__

12.02.2008 21:16:10 org.mortbay.jetty.servlet.ServletHandler handle             WARNING: Error for /help/index.jsp
java.lang.IncompatibleClassChangeError: Class org.apache.jasper.servlet.JspServlet does not implement the requested interface javax.servlet.Servlet
        at org.eclipse.equinox.jsp.jasper.JspServlet.init(JspServlet.java:81)
        at org.eclipse.equinox.http.registry.internal.ServletManager$ServletWrapper.initializeDelegate(ServletManager.java:195)
        at org.eclipse.equinox.http.registry.internal.ServletManager$ServletWrapper.service(ServletManager.java:179)
        at org.eclipse.equinox.http.servlet.internal.ServletRegistration.handleRequest(ServletRegistration.java:90)
        at org.eclipse.equinox.http.servlet.internal.ProxyServlet.processAlias(ProxyServlet.java:109)
        at org.eclipse.equinox.http.servlet.internal.ProxyServlet.service(ProxyServlet.java:75)
        at javax.servlet.http.HttpServlet.service(HttpServlet.java:803)
        at org.eclipse.equinox.http.jetty.internal.HttpServerManager$InternalHttpServiceServlet.service(HttpServerManager.java:280)   
        at org.mortbay.jetty.servlet.ServletHolder.handle(ServletHolder.java:428)
        at org.mortbay.jetty.servlet.ServletHandler.dispatch(ServletHandler.java:677)
        at org.mortbay.jetty.servlet.ServletHandler.handle(ServletHandler.java:568)
        at org.mortbay.http.HttpContext.handle(HttpContext.java:1530)
        at org.mortbay.http.HttpContext.handle(HttpContext.java:1482)
        at org.mortbay.http.HttpServer.service(HttpServer.java:909)
        at org.mortbay.http.HttpConnection.service(HttpConnection.java:820)
        at org.mortbay.http.HttpConnection.handleNext(HttpConnection.java:986)
        at org.mortbay.http.HttpConnection.handle(HttpConnection.java:837)
        at org.mortbay.http.SocketListener.handleConnection(SocketListener.java:245)
        at org.mortbay.util.ThreadedServer.handle(ThreadedServer.java:357)
        at org.mortbay.util.ThreadPool$PoolThread.run(ThreadPool.java:534)



#plugins/org.eclipse.core.filesystem/natives/unix/linux/Makefile:JAVA_HOME= ~/vm/sun142
    # note: disabled in 16 and enabled in 18 again
    if ($apprelease < 18) {
	# disable java-1.6.0 code
	$jpp->get_section('package','')->unshift_body('%def_without java6'."\n");
	$jpp->get_section('prep')->subst_after(qr'%if\s+%{gcj_support}','%if_without java6', qr'# remove jdt.apt.pluggable.core, jdt.compiler.tool and org.eclipse.jdt.compiler.apt as they require a JVM that supports Java 1.6');
	$jpp->get_section('prep')->subst_after(qr'%if\s+%{gcj_support}','%if_without java6', qr'the ia64 strings with ppc64');
	$jpp->get_section('build')->subst_after(qr'%if\s+%{gcj_support}','%if_without java6', qr'# Build the rest of Eclipse');
	$jpp->get_section('files','jdt')->subst(qr'%else','%endif'."\n"."%if_with java6");
    }
#    $jpp->get_section('package','')->unshift_body('BuildRequires: eclipse-bootstrap-bundle'."\n");

# now we use theme
$jpp->get_section('package','')->subst(qr'%{name}-fedora-splash-3.[0-9].[0-9].png', '%{name}-altlinux-splash-3.3.0.png');
$jpp->copy_to_sources('eclipse-altlinux-splash-3.3.0.png');
