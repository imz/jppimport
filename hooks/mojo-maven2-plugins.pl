#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('BuildRequires: modello-maven-plugin saxpath jakarta-commons-primitives maven-doxia-sitetools plexus-containers-container-default plexus-component-annotations'."\n");
    $jpp->get_section('package','-n mojo-maven2-plugin-antlr')->push_body('Provides: maven2-plugin-antlr = 2.0.4'."\n");
    $jpp->get_section('package','-n mojo-maven2-plugin-cobertura')->push_body('Requires: cobertura'."\n");

    $jpp->add_patch('mojo-maven2-plugins-17-javancss-maven-plugin-alt-javancss-3x-alt.patch',
		    STRIP=>0);#, NUMBER=>233);
    $jpp->add_patch('mojo-maven2-plugins-mojo-antlr-plugin-alt-doxia-update.patch',
		    STRIP=>1);#, NUMBER=>234);
};

__END__

#    $jpp->get_section('package','')->subst(qr'BuildRequires: batik','BuildRequires: xmlgraphics-batik');

    $jpp->get_section('build')->push_body_after('# javacc
mkdir -p $MAVEN_REPO_LOCAL/javacc
ln -s $(build-classpath javacc) $MAVEN_REPO_LOCAL/javacc/javacc.jar
', qr'/tanukisoft/wrapper-delta-pack.jar');


    # hacks for missing deps
#    $jpp->disable_package('-n mojo-maven2-plugin-findbugs');
#    $jpp->disable_package('-n mojo-maven2-plugin-hibernate2');
#    $jpp->disable_package('-n mojo-maven2-plugin-springbeandoc');
#    $jpp->disable_package('-n mojo-maven2-plugin-sysdeo-tomcat');
#    $jpp->disable_package('-n mojo-maven2-plugin-tomcat');
    $jpp->disable_package('-n mojo-maven2-plugin-xfire');
    $jpp->disable_package('-n mojo-maven2-plugin-jasperreports');
    $jpp->disable_package('-n mojo-maven2-plugin-jspc');
    $jpp->disable_package('-n mojo-maven2-jspc-compiler-tomcat5');
    $jpp->disable_package('-n mojo-maven2-jspc-compiler-tomcat6');
#    $jpp->disable_package('-n mojo-maven2-plugin-retrotranslator');
#    $jpp->disable_package('-n mojo-maven2-plugin-selenium');
#    $jpp->disable_package('-n mojo-maven2-plugin-shitty');
#    $jpp->disable_package('-n ');
#    $jpp->disable_package('-n ');

#    $jpp->get_section('package','')->subst(qr'BuildRequires: hibernate2','#BuildRequires: hibernate2');
#    $jpp->get_section('package','')->subst(qr'BuildRequires: spring2','#BuildRequires: spring2');
#    $jpp->get_section('package','')->subst(qr'BuildRequires: spring-beandoc','#BuildRequires: spring-beandoc');
#    $jpp->get_section('package','')->subst(qr'BuildRequires: xbean','#BuildRequires: xbean');
#    $jpp->get_section('package','')->subst(qr'BuildRequires: tomcat6','#BuildRequires: tomcat6');

    $jpp->get_section('package','')->subst(qr'BuildRequires: xfire','#BuildRequires: xfire');
#    $jpp->get_section('package','')->subst(qr'BuildRequires: gmaven','#BuildRequires: gmaven');
};

__END__
TODO:
#change packaging from tar.gz
#/tanukisoft/wrapper-delta-pack/3.2.3/wrapper-delta-pack-3.2.3.tar.gz
sed -i s,tar.gz,jar, appassembler/appassembler-maven-plugin/pom.xml

#subst 's,<module>findbugs-maven-plugin</module>,,' pom.xml
#subst 's,<module>hibernate2-maven-plugin</module>,,' pom.xml
subst 's,<module>jasperreports-maven-plugin</module>,,' pom.xml # old jasperreports?
subst 's,<module>jspc</module>,,' pom.xml #gmaven
#subst 's,<module>retrotranslator-maven-plugin</module>,,' pom.xml #gmaven
#subst 's,<module>selenium-maven-plugin</module>,,' pom.xml #gmaven
#subst 's,<module>shitty-maven-plugin</module>,,' pom.xml #gmaven
#subst 's,<module>sysdeo-tomcat-maven-plugin</module>,,' pom.xml # tomcat5?
#subst 's,<module>tomcat-maven-plugin</module>,,' pom.xml #tomcat5 can also be used?
#subst 's,<module>maven-springbeandoc-plugin</module>,,' mojo-sandbox/pom.xml
subst 's,<module>xfire-maven-plugin</module>,,' mojo-sandbox/pom.xml
subst 's,,,' pom.xml
subst 's,,,' pom.xml

# maven 2.0.8
subst 's,<module>dashboard-maven-plugin</module>,<!--2.0.8 nocompile<module>dashboard-maven-plugin</module>-->,' mojo-sandbox/pom.xml

subst 's,<artifactId>plexus-component-api</artifactId>,<artifactId>containers-component-api</artifactId>' mojo-sandbox/maven-diagram-maker/connector-api/pom.xml
subst 's,<artifactId>plexus-containers-container-default</artifactId>,<artifactId>containers-container-default</artifactId>' mojo-sandbox/maven-diagram-maker/connector-api/pom.xml

#######################################################################

# Remove dependencies on org.codehaus.doxia.* (it is now
# org.apache.maven.doxia, and in the interest of maintaining just one
# doxia jar, we substitute things accordingly)

for i in \
./antlr-maven-plugin/src/main/java/org/codehaus/mojo/antlr/AntlrHtmlReport.java \
./clirr-maven-plugin/src/main/java/org/codehaus/mojo/clirr/ClirrReport.java \
./cobertura-maven-plugin/src/main/java/org/codehaus/mojo/cobertura/CoberturaReportMojo.java \
./javancss-maven-plugin/src/main/java/org/codehaus/mojo/javancss/AbstractNcssReportGenerator.java \
./javancss-maven-plugin/src/main/java/org/codehaus/mojo/javancss/NcssAggregateReportGenerator.java \
./javancss-maven-plugin/src/main/java/org/codehaus/mojo/javancss/NcssReportGenerator.java \
./javancss-maven-plugin/src/main/java/org/codehaus/mojo/javancss/NcssReportMojo.java \
./jdiff-maven-plugin/src/main/java/org/apache/maven/plugin/jdiff/JDiffMojo.java \
./mojo-sandbox/simian-report-maven-plugin/src/main/java/org/codehaus/mojo/simian/SimianReportMojo.java \
./mojo-sandbox/simian-report-maven-plugin/src/main/java/org/codehaus/mojo/simian/SimianReportMojo.java \
./smc-maven-plugin/src/main/java/org/codehaus/mojo/smc/SmcReportMojo.java \
./taglist-maven-plugin/src/main/java/org/codehaus/mojo/taglist/TagListReport.java \
; do
    sed -i -e s:org.codehaus.doxia.sink.Sink:org.apache.maven.doxia.sink.Sink:g $i
    sed -i -e s:org.codehaus.doxia.site.renderer.SiteRenderer:org.apache.maven.doxia.siterenderer.Renderer:g $i
    sed -i -r -e s:\(\\s+\)SiteRenderer\(\\s+\):\\1Renderer\\2:g $i
done

--- mojo-maven2-plugins.spec	2009-02-12 20:25:14 +0000
+++ mojo-maven2-plugins.spec	2009-02-13 08:57:13 +0000
@@ -2165,6 +2165,19 @@
 %patch79 -b .sav79
 %patch80 -b .sav80
 
+subst 's,<module>findbugs-maven-plugin</module>,,' pom.xml
+subst 's,<module>hibernate2-maven-plugin</module>,,' pom.xml
+subst 's,<module>jasperreports-maven-plugin</module>,,' pom.xml
+subst 's,<module>jspc</module>,,' pom.xml #gmaven
+subst 's,<module>retrotranslator-maven-plugin</module>,,' pom.xml #gmaven
+subst 's,<module>selenium-maven-plugin</module>,,' pom.xml #gmaven
+subst 's,<module>shitty-maven-plugin</module>,,' pom.xml #gmaven
+subst 's,<module>sysdeo-tomcat-maven-plugin</module>,,' pom.xml
+subst 's,<module>tomcat-maven-plugin</module>,,' pom.xml #tomcat5 can also be used?
+subst 's,<module>maven-springbeandoc-plugin</module>,,' mojo-sandbox/pom.xml
+subst 's,<module>xfire-maven-plugin</module>,,' mojo-sandbox/pom.xml
+
+
 %build
 export MAVEN_OPTS="-Xmx512m"
 export MAVEN_REPO_LOCAL=`pwd`/%{repo_dir}
@@ -2400,19 +2413,19 @@
 
 ver=$(echo %{findbugs_namedversion} | sed -e 's/-SNAPSHOT//')
 nam=findbugs-maven-plugin
-install -m 644 ${nam}/target/${nam}-%{findbugs_namedversion}.jar \
-               $RPM_BUILD_ROOT%{_javadir}/mojo/${nam}-${ver}.jar
-ln -sf ${nam}-${ver}.jar $RPM_BUILD_ROOT%{_javadir}/mojo/${nam}.jar
-install -m 644 ${nam}/pom.xml $RPM_BUILD_ROOT%{_datadir}/maven2/poms/JPP.mojo-${nam}.pom
-%add_to_maven_depmap org.codehaus.mojo ${nam} ${ver} JPP/mojo ${nam}
+#install -m 644 ${nam}/target/${nam}-%{findbugs_namedversion}.jar \
+#               $RPM_BUILD_ROOT%{_javadir}/mojo/${nam}-${ver}.jar
+#ln -sf ${nam}-${ver}.jar $RPM_BUILD_ROOT%{_javadir}/mojo/${nam}.jar
+#install -m 644 ${nam}/pom.xml $RPM_BUILD_ROOT%{_datadir}/maven2/poms/JPP.mojo-${nam}.pom
+#%add_to_maven_depmap org.codehaus.mojo ${nam} ${ver} JPP/mojo ${nam}
 
 ver=$(echo %{hibernate2_namedversion} | sed -e 's/-SNAPSHOT//')
 nam=hibernate2-maven-plugin
-install -m 644 ${nam}/target/${nam}-%{hibernate2_namedversion}.jar \
-               $RPM_BUILD_ROOT%{_javadir}/mojo/${nam}-${ver}.jar
-ln -sf ${nam}-${ver}.jar $RPM_BUILD_ROOT%{_javadir}/mojo/${nam}.jar
-install -m 644 ${nam}/pom.xml $RPM_BUILD_ROOT%{_datadir}/maven2/poms/JPP.mojo-${nam}.pom
-%add_to_maven_depmap org.codehaus.mojo ${nam} ${ver} JPP/mojo ${nam}
+#install -m 644 ${nam}/target/${nam}-%{hibernate2_namedversion}.jar \
+#               $RPM_BUILD_ROOT%{_javadir}/mojo/${nam}-${ver}.jar
+#ln -sf ${nam}-${ver}.jar $RPM_BUILD_ROOT%{_javadir}/mojo/${nam}.jar
+#install -m 644 ${nam}/pom.xml $RPM_BUILD_ROOT%{_datadir}/maven2/poms/JPP.mojo-${nam}.pom
+#%add_to_maven_depmap org.codehaus.mojo ${nam} ${ver} JPP/mojo ${nam}
 
 ver=$(echo %{hibernate3_namedversion} | sed -e 's/-SNAPSHOT//')
 install -m 644 hibernate3/pom.xml $RPM_BUILD_ROOT%{_datadir}/maven2/poms/JPP.mojo-hibernate3.pom
@@ -2534,35 +2547,35 @@
 %add_to_maven_depmap org.codehaus.mojo ${nam} ${ver} JPP/mojo ${nam}
 
 ver=$(echo %{jspc_namedversion} | sed -e 's/-SNAPSHOT//')
-install -m 644 jspc/pom.xml $RPM_BUILD_ROOT%{_datadir}/maven2/poms/JPP.mojo-jspc.pom
-%add_to_maven_depmap org.codehaus.mojo.jspc jspc ${ver} JPP/mojo jspc
-install -m 644 jspc/jspc-compilers/pom.xml $RPM_BUILD_ROOT%{_datadir}/maven2/poms/JPP.mojo-jspc-compilers.pom
-%add_to_maven_depmap org.codehaus.mojo.jspc jspc-compilers ${ver} JPP/mojo jspc-compilers
+#install -m 644 jspc/pom.xml $RPM_BUILD_ROOT%{_datadir}/maven2/poms/JPP.mojo-jspc.pom
+#%add_to_maven_depmap org.codehaus.mojo.jspc jspc ${ver} JPP/mojo jspc
+#install -m 644 jspc/jspc-compilers/pom.xml $RPM_BUILD_ROOT%{_datadir}/maven2/poms/JPP.mojo-jspc-compilers.pom
+#%add_to_maven_depmap org.codehaus.mojo.jspc jspc-compilers ${ver} JPP/mojo jspc-compilers
 
 nam=jspc-compiler-api
-install -m 644 jspc/${nam}/target/${nam}-%{jspc_namedversion}.jar \
-               $RPM_BUILD_ROOT%{_javadir}/mojo/${nam}-${ver}.jar
-ln -sf ${nam}-${ver}.jar $RPM_BUILD_ROOT%{_javadir}/mojo/${nam}.jar
-install -m 644 jspc/${nam}/pom.xml $RPM_BUILD_ROOT%{_datadir}/maven2/poms/JPP.mojo-${nam}.pom
-%add_to_maven_depmap org.codehaus.mojo.jspc ${nam} ${ver} JPP/mojo ${nam}
+#install -m 644 jspc/${nam}/target/${nam}-%{jspc_namedversion}.jar \
+#               $RPM_BUILD_ROOT%{_javadir}/mojo/${nam}-${ver}.jar
+#ln -sf ${nam}-${ver}.jar $RPM_BUILD_ROOT%{_javadir}/mojo/${nam}.jar
+#install -m 644 jspc/${nam}/pom.xml $RPM_BUILD_ROOT%{_datadir}/maven2/poms/JPP.mojo-${nam}.pom
+#%add_to_maven_depmap org.codehaus.mojo.jspc ${nam} ${ver} JPP/mojo ${nam}
 nam=jspc-compiler-tomcat5
-install -m 644 jspc/jspc-compilers/${nam}/target/${nam}-%{jspc_namedversion}.jar \
-               $RPM_BUILD_ROOT%{_javadir}/mojo/${nam}-${ver}.jar
-ln -sf ${nam}-${ver}.jar $RPM_BUILD_ROOT%{_javadir}/mojo/${nam}.jar
-install -m 644 jspc/jspc-compilers/${nam}/pom.xml $RPM_BUILD_ROOT%{_datadir}/maven2/poms/JPP.mojo-${nam}.pom
-%add_to_maven_depmap org.codehaus.mojo.jspc ${nam} ${ver} JPP/mojo ${nam}
+#install -m 644 jspc/jspc-compilers/${nam}/target/${nam}-%{jspc_namedversion}.jar \
+#               $RPM_BUILD_ROOT%{_javadir}/mojo/${nam}-${ver}.jar
+#ln -sf ${nam}-${ver}.jar $RPM_BUILD_ROOT%{_javadir}/mojo/${nam}.jar
+#install -m 644 jspc/jspc-compilers/${nam}/pom.xml $RPM_BUILD_ROOT%{_datadir}/maven2/poms/JPP.mojo-${nam}.pom
+#%add_to_maven_depmap org.codehaus.mojo.jspc ${nam} ${ver} JPP/mojo ${nam}
 nam=jspc-compiler-tomcat6
-install -m 644 jspc/jspc-compilers/${nam}/target/${nam}-%{jspc_namedversion}.jar \
-               $RPM_BUILD_ROOT%{_javadir}/mojo/${nam}-${ver}.jar
-ln -sf ${nam}-${ver}.jar $RPM_BUILD_ROOT%{_javadir}/mojo/${nam}.jar
-install -m 644 jspc/jspc-compilers/${nam}/pom.xml $RPM_BUILD_ROOT%{_datadir}/maven2/poms/JPP.mojo-${nam}.pom
-%add_to_maven_depmap org.codehaus.mojo.jspc ${nam} ${ver} JPP/mojo ${nam}
+#install -m 644 jspc/jspc-compilers/${nam}/target/${nam}-%{jspc_namedversion}.jar \
+#               $RPM_BUILD_ROOT%{_javadir}/mojo/${nam}-${ver}.jar
+#ln -sf ${nam}-${ver}.jar $RPM_BUILD_ROOT%{_javadir}/mojo/${nam}.jar
+#install -m 644 jspc/jspc-compilers/${nam}/pom.xml $RPM_BUILD_ROOT%{_datadir}/maven2/poms/JPP.mojo-${nam}.pom
+#%add_to_maven_depmap org.codehaus.mojo.jspc ${nam} ${ver} JPP/mojo ${nam}
 nam=jspc-maven-plugin
-install -m 644 jspc/${nam}/target/${nam}-%{jspc_namedversion}.jar \
-               $RPM_BUILD_ROOT%{_javadir}/mojo/${nam}-${ver}.jar
-ln -sf ${nam}-${ver}.jar $RPM_BUILD_ROOT%{_javadir}/mojo/${nam}.jar
-install -m 644 jspc/${nam}/pom.xml $RPM_BUILD_ROOT%{_datadir}/maven2/poms/JPP.mojo-${nam}.pom
-%add_to_maven_depmap org.codehaus.mojo.jspc ${nam} ${ver} JPP/mojo ${nam}
+#install -m 644 jspc/${nam}/target/${nam}-%{jspc_namedversion}.jar \
+#               $RPM_BUILD_ROOT%{_javadir}/mojo/${nam}-${ver}.jar
+#ln -sf ${nam}-${ver}.jar $RPM_BUILD_ROOT%{_javadir}/mojo/${nam}.jar
+#install -m 644 jspc/${nam}/pom.xml $RPM_BUILD_ROOT%{_datadir}/maven2/poms/JPP.mojo-${nam}.pom
+#%add_to_maven_depmap org.codehaus.mojo.jspc ${nam} ${ver} JPP/mojo ${nam}
 
 ver=$(echo %{keytool_namedversion} | sed -e 's/-SNAPSHOT//')
 nam=keytool-maven-plugin
@@ -2817,11 +2830,11 @@
 
 ver=$(echo %{jasperreports_namedversion} | sed -e 's/-SNAPSHOT//')
 nam=jasperreports-maven-plugin
-install -m 644 ${nam}/target/${nam}-%{jasperreports_namedversion}.jar \
-               $RPM_BUILD_ROOT%{_javadir}/mojo/${nam}-${ver}.jar
-ln -sf ${nam}-${ver}.jar $RPM_BUILD_ROOT%{_javadir}/mojo/${nam}.jar
-install -m 644 ${nam}/pom.xml $RPM_BUILD_ROOT%{_datadir}/maven2/poms/JPP.mojo-${nam}.pom
-%add_to_maven_depmap org.codehaus.mojo ${nam} ${ver} JPP/mojo ${nam}
+#install -m 644 ${nam}/target/${nam}-%{jasperreports_namedversion}.jar \
+#               $RPM_BUILD_ROOT%{_javadir}/mojo/${nam}-${ver}.jar
+#ln -sf ${nam}-${ver}.jar $RPM_BUILD_ROOT%{_javadir}/mojo/${nam}.jar
+#install -m 644 ${nam}/pom.xml $RPM_BUILD_ROOT%{_datadir}/maven2/poms/JPP.mojo-${nam}.pom
+#%add_to_maven_depmap org.codehaus.mojo ${nam} ${ver} JPP/mojo ${nam}
 
 ver=$(echo %{jaxws_namedversion} | sed -e 's/-SNAPSHOT//')
 nam=jaxws-maven-plugin
@@ -3010,11 +3023,11 @@
 
 ver=$(echo %{springbeandoc_namedversion} | sed -e 's/-SNAPSHOT//')
 nam=maven-springbeandoc-plugin
-install -m 644 mojo-sandbox/${nam}/target/${nam}-%{springbeandoc_namedversion}.jar \
-               $RPM_BUILD_ROOT%{_javadir}/mojo/${nam}-${ver}.jar
-ln -sf ${nam}-${ver}.jar $RPM_BUILD_ROOT%{_javadir}/mojo/${nam}.jar
-install -m 644 mojo-sandbox/${nam}/pom.xml $RPM_BUILD_ROOT%{_datadir}/maven2/poms/JPP.mojo-${nam}.pom
-%add_to_maven_depmap org.codehaus.mojo ${nam} ${ver} JPP/mojo ${nam}
+#install -m 644 mojo-sandbox/${nam}/target/${nam}-%{springbeandoc_namedversion}.jar \
+#               $RPM_BUILD_ROOT%{_javadir}/mojo/${nam}-${ver}.jar
+#ln -sf ${nam}-${ver}.jar $RPM_BUILD_ROOT%{_javadir}/mojo/${nam}.jar
+#install -m 644 mojo-sandbox/${nam}/pom.xml $RPM_BUILD_ROOT%{_datadir}/maven2/poms/JPP.mojo-${nam}.pom
+#%add_to_maven_depmap org.codehaus.mojo ${nam} ${ver} JPP/mojo ${nam}
 
 ver=$(echo %{testing_simple_namedversion} | sed -e 's/-SNAPSHOT//')
 nam=maven-simple-plugin
@@ -3135,11 +3148,11 @@
 ver=$(echo %{sysdeo_tomcat_namedversion} | sed -e 's/-SNAPSHOT//')
 dnam=sysdeo-tomcat-maven-plugin
 jnam=sysdeo-tomcat-plugin
-install -m 644 ${dnam}/target/${dnam}-%{sysdeo_tomcat_namedversion}.jar \
-               $RPM_BUILD_ROOT%{_javadir}/mojo/${jnam}-${ver}.jar
-ln -sf ${jnam}-${ver}.jar $RPM_BUILD_ROOT%{_javadir}/mojo/${jnam}.jar
-install -m 644 ${dnam}/pom.xml $RPM_BUILD_ROOT%{_datadir}/maven2/poms/JPP.mojo-${jnam}.pom
-%add_to_maven_depmap org.codehaus.mojo ${jnam} ${ver} JPP/mojo ${jnam}
+#install -m 644 ${dnam}/target/${dnam}-%{sysdeo_tomcat_namedversion}.jar \
+#               $RPM_BUILD_ROOT%{_javadir}/mojo/${jnam}-${ver}.jar
+#ln -sf ${jnam}-${ver}.jar $RPM_BUILD_ROOT%{_javadir}/mojo/${jnam}.jar
+#install -m 644 ${dnam}/pom.xml $RPM_BUILD_ROOT%{_datadir}/maven2/poms/JPP.mojo-${jnam}.pom
+#%add_to_maven_depmap org.codehaus.mojo ${jnam} ${ver} JPP/mojo ${jnam}
 
 ver=$(echo %{visibroker_namedversion} | sed -e 's/-SNAPSHOT//')
 nam=visibroker-maven-plugin
@@ -3167,11 +3180,11 @@
 
 ver=$(echo %{xfire_namedversion} | sed -e 's/-SNAPSHOT//')
 nam=xfire-maven-plugin
-install -m 644 mojo-sandbox/${nam}/target/${nam}-%{xfire_namedversion}.jar \
-               $RPM_BUILD_ROOT%{_javadir}/mojo/${nam}-${ver}.jar
-ln -sf ${nam}-${ver}.jar $RPM_BUILD_ROOT%{_javadir}/mojo/${nam}.jar
-install -m 644 mojo-sandbox/${nam}/pom.xml $RPM_BUILD_ROOT%{_datadir}/maven2/poms/JPP.mojo-${nam}.pom
-%add_to_maven_depmap org.codehaus.mojo ${nam} ${ver} JPP/mojo ${nam}
+#install -m 644 mojo-sandbox/${nam}/target/${nam}-%{xfire_namedversion}.jar \
+#               $RPM_BUILD_ROOT%{_javadir}/mojo/${nam}-${ver}.jar
+#ln -sf ${nam}-${ver}.jar $RPM_BUILD_ROOT%{_javadir}/mojo/${nam}.jar
+#install -m 644 mojo-sandbox/${nam}/pom.xml $RPM_BUILD_ROOT%{_datadir}/maven2/poms/JPP.mojo-${nam}.pom
+#%add_to_maven_depmap org.codehaus.mojo ${nam} ${ver} JPP/mojo ${nam}
 
 ver=$(echo %{xjc_namedversion} | sed -e 's/-SNAPSHOT//')
 nam=xjc-maven-plugin
@@ -3239,11 +3252,11 @@
 
 ver=$(echo %{retrotranslator_namedversion} | sed -e 's/-SNAPSHOT//')
 nam=retrotranslator-maven-plugin
-install -m 644 ${nam}/target/${nam}-%{retrotranslator_namedversion}.jar \
-               $RPM_BUILD_ROOT%{_javadir}/mojo/${nam}-${ver}.jar
-ln -sf ${nam}-${ver}.jar $RPM_BUILD_ROOT%{_javadir}/mojo/${nam}.jar
-install -m 644 ${nam}/pom.xml $RPM_BUILD_ROOT%{_datadir}/maven2/poms/JPP.mojo-${nam}.pom
-%add_to_maven_depmap org.codehaus.mojo ${nam} ${ver} JPP/mojo ${nam}
+#install -m 644 ${nam}/target/${nam}-%{retrotranslator_namedversion}.jar \
+#               $RPM_BUILD_ROOT%{_javadir}/mojo/${nam}-${ver}.jar
+#ln -sf ${nam}-${ver}.jar $RPM_BUILD_ROOT%{_javadir}/mojo/${nam}.jar
+#install -m 644 ${nam}/pom.xml $RPM_BUILD_ROOT%{_datadir}/maven2/poms/JPP.mojo-${nam}.pom
+#%add_to_maven_depmap org.codehaus.mojo ${nam} ${ver} JPP/mojo ${nam}
 
 ver=$(echo %{sablecc_namedversion} | sed -e 's/-SNAPSHOT//')
 nam=sablecc-maven-plugin
@@ -3255,19 +3268,19 @@
 
 ver=$(echo %{selenium_namedversion} | sed -e 's/-SNAPSHOT//')
 nam=selenium-maven-plugin
-install -m 644 ${nam}/target/${nam}-%{selenium_namedversion}.jar \
-               $RPM_BUILD_ROOT%{_javadir}/mojo/${nam}-${ver}.jar
-ln -sf ${nam}-${ver}.jar $RPM_BUILD_ROOT%{_javadir}/mojo/${nam}.jar
-install -m 644 ${nam}/pom.xml $RPM_BUILD_ROOT%{_datadir}/maven2/poms/JPP.mojo-${nam}.pom
-%add_to_maven_depmap org.codehaus.mojo ${nam} ${ver} JPP/mojo ${nam}
+#install -m 644 ${nam}/target/${nam}-%{selenium_namedversion}.jar \
+#               $RPM_BUILD_ROOT%{_javadir}/mojo/${nam}-${ver}.jar
+#ln -sf ${nam}-${ver}.jar $RPM_BUILD_ROOT%{_javadir}/mojo/${nam}.jar
+#install -m 644 ${nam}/pom.xml $RPM_BUILD_ROOT%{_datadir}/maven2/poms/JPP.mojo-${nam}.pom
+#%add_to_maven_depmap org.codehaus.mojo ${nam} ${ver} JPP/mojo ${nam}
 
 ver=$(echo %{shitty_namedversion} | sed -e 's/-SNAPSHOT//')
 nam=shitty-maven-plugin
-install -m 644 ${nam}/target/${nam}-%{shitty_namedversion}.jar \
-               $RPM_BUILD_ROOT%{_javadir}/mojo/${nam}-${ver}.jar
-ln -sf ${nam}-${ver}.jar $RPM_BUILD_ROOT%{_javadir}/mojo/${nam}.jar
-install -m 644 ${nam}/pom.xml $RPM_BUILD_ROOT%{_datadir}/maven2/poms/JPP.mojo-${nam}.pom
-%add_to_maven_depmap org.codehaus.mojo ${nam} ${ver} JPP/mojo ${nam}
+#install -m 644 ${nam}/target/${nam}-%{shitty_namedversion}.jar \
+#               $RPM_BUILD_ROOT%{_javadir}/mojo/${nam}-${ver}.jar
+#ln -sf ${nam}-${ver}.jar $RPM_BUILD_ROOT%{_javadir}/mojo/${nam}.jar
+#install -m 644 ${nam}/pom.xml $RPM_BUILD_ROOT%{_datadir}/maven2/poms/JPP.mojo-${nam}.pom
+#%add_to_maven_depmap org.codehaus.mojo ${nam} ${ver} JPP/mojo ${nam}
 
 ver=$(echo %{smc_namedversion} | sed -e 's/-SNAPSHOT//')
 nam=smc-maven-plugin
@@ -3305,11 +3318,11 @@
 
 ver=$(echo %{tomcat_namedversion} | sed -e 's/-SNAPSHOT//')
 nam=tomcat-maven-plugin
-install -m 644 ${nam}/target/${nam}-%{tomcat_namedversion}.jar \
-               $RPM_BUILD_ROOT%{_javadir}/mojo/${nam}-${ver}.jar
-ln -sf ${nam}-${ver}.jar $RPM_BUILD_ROOT%{_javadir}/mojo/${nam}.jar
-install -m 644 ${nam}/pom.xml $RPM_BUILD_ROOT%{_datadir}/maven2/poms/JPP.mojo-${nam}.pom
-%add_to_maven_depmap org.codehaus.mojo ${nam} ${ver} JPP/mojo ${nam}
+#install -m 644 ${nam}/target/${nam}-%{tomcat_namedversion}.jar \
+#               $RPM_BUILD_ROOT%{_javadir}/mojo/${nam}-${ver}.jar
+#ln -sf ${nam}-${ver}.jar $RPM_BUILD_ROOT%{_javadir}/mojo/${nam}.jar
+#install -m 644 ${nam}/pom.xml $RPM_BUILD_ROOT%{_datadir}/maven2/poms/JPP.mojo-${nam}.pom
+#%add_to_maven_depmap org.codehaus.mojo ${nam} ${ver} JPP/mojo ${nam}
 
 ver=$(echo %{pack200_anttasks_namedversion} | sed -e 's/-SNAPSHOT//')
 nam=webstart-pack200-anttasks
@@ -3434,10 +3447,10 @@
 cp -pr exec-maven-plugin/target/site/apidocs/* $RPM_BUILD_ROOT%{_javadocdir}/%{name}-%{version}/exec-maven-plugin
 
 install -d -m 755 $RPM_BUILD_ROOT%{_javadocdir}/%{name}-%{version}/findbugs-maven-plugin
-cp -pr findbugs-maven-plugin/target/site/apidocs/* $RPM_BUILD_ROOT%{_javadocdir}/%{name}-%{version}/findbugs-maven-plugin
+#cp -pr findbugs-maven-plugin/target/site/apidocs/* $RPM_BUILD_ROOT%{_javadocdir}/%{name}-%{version}/findbugs-maven-plugin
 
 install -d -m 755 $RPM_BUILD_ROOT%{_javadocdir}/%{name}-%{version}/hibernate2-maven-plugin
-cp -pr hibernate2-maven-plugin/target/site/apidocs/* $RPM_BUILD_ROOT%{_javadocdir}/%{name}-%{version}/hibernate2-maven-plugin
+#cp -pr hibernate2-maven-plugin/target/site/apidocs/* $RPM_BUILD_ROOT%{_javadocdir}/%{name}-%{version}/hibernate2-maven-plugin
 
 install -d -m 755 $RPM_BUILD_ROOT%{_javadocdir}/%{name}-%{version}/hibernate3-maven-plugin
 cp -pr hibernate3/hibernate3-maven-plugin/target/site/apidocs/* $RPM_BUILD_ROOT%{_javadocdir}/%{name}-%{version}/hibernate3-maven-plugin
@@ -3476,13 +3489,13 @@
 cp -pr jruby-maven-plugin/target/site/apidocs/* $RPM_BUILD_ROOT%{_javadocdir}/%{name}-%{version}/jruby-maven-plugin
 
 install -d -m 755 $RPM_BUILD_ROOT%{_javadocdir}/%{name}-%{version}/jspc-compiler-api
-cp -pr jspc/jspc-compiler-api/target/site/apidocs/* $RPM_BUILD_ROOT%{_javadocdir}/%{name}-%{version}/jspc-compiler-api
+#cp -pr jspc/jspc-compiler-api/target/site/apidocs/* $RPM_BUILD_ROOT%{_javadocdir}/%{name}-%{version}/jspc-compiler-api
 install -d -m 755 $RPM_BUILD_ROOT%{_javadocdir}/%{name}-%{version}/jspc-compiler-tomcat5
-cp -pr jspc/jspc-compilers/jspc-compiler-tomcat5/target/site/apidocs/* $RPM_BUILD_ROOT%{_javadocdir}/%{name}-%{version}/jspc-compiler-tomcat5
+#cp -pr jspc/jspc-compilers/jspc-compiler-tomcat5/target/site/apidocs/* $RPM_BUILD_ROOT%{_javadocdir}/%{name}-%{version}/jspc-compiler-tomcat5
 install -d -m 755 $RPM_BUILD_ROOT%{_javadocdir}/%{name}-%{version}/jspc-compiler-tomcat6
-cp -pr jspc/jspc-compilers/jspc-compiler-tomcat6/target/site/apidocs/* $RPM_BUILD_ROOT%{_javadocdir}/%{name}-%{version}/jspc-compiler-tomcat6
+#cp -pr jspc/jspc-compilers/jspc-compiler-tomcat6/target/site/apidocs/* $RPM_BUILD_ROOT%{_javadocdir}/%{name}-%{version}/jspc-compiler-tomcat6
 install -d -m 755 $RPM_BUILD_ROOT%{_javadocdir}/%{name}-%{version}/jspc-maven-plugin
-cp -pr jspc/jspc-maven-plugin/target/site/apidocs/* $RPM_BUILD_ROOT%{_javadocdir}/%{name}-%{version}/jspc-maven-plugin
+#cp -pr jspc/jspc-maven-plugin/target/site/apidocs/* $RPM_BUILD_ROOT%{_javadocdir}/%{name}-%{version}/jspc-maven-plugin
 
 install -d -m 755 $RPM_BUILD_ROOT%{_javadocdir}/%{name}-%{version}/keytool-maven-plugin
 cp -pr keytool-maven-plugin/target/site/apidocs/* $RPM_BUILD_ROOT%{_javadocdir}/%{name}-%{version}/keytool-maven-plugin
@@ -3560,7 +3573,7 @@
 cp -pr mojo-sandbox/jardiff-maven-plugin/target/site/apidocs/* $RPM_BUILD_ROOT%{_javadocdir}/%{name}-%{version}/jardiff-maven-plugin
 
 install -d -m 755 $RPM_BUILD_ROOT%{_javadocdir}/%{name}-%{version}/jasperreports-maven-plugin
-cp -pr jasperreports-maven-plugin/target/site/apidocs/* $RPM_BUILD_ROOT%{_javadocdir}/%{name}-%{version}/jasperreports-maven-plugin
+#cp -pr jasperreports-maven-plugin/target/site/apidocs/* $RPM_BUILD_ROOT%{_javadocdir}/%{name}-%{version}/jasperreports-maven-plugin
 
 install -d -m 755 $RPM_BUILD_ROOT%{_javadocdir}/%{name}-%{version}/jaxws-maven-plugin
 cp -pr mojo-sandbox/jaxws-maven-plugin/target/site/apidocs/* $RPM_BUILD_ROOT%{_javadocdir}/%{name}-%{version}/jaxws-maven-plugin
@@ -3620,7 +3633,7 @@
 cp -pr mojo-sandbox/maven-hsqldb-plugin/target/site/apidocs/* $RPM_BUILD_ROOT%{_javadocdir}/%{name}-%{version}/maven-hsqldb-plugin
 
 install -d -m 755 $RPM_BUILD_ROOT%{_javadocdir}/%{name}-%{version}/maven-springbeandoc-plugin
-cp -pr mojo-sandbox/maven-springbeandoc-plugin/target/site/apidocs/* $RPM_BUILD_ROOT%{_javadocdir}/%{name}-%{version}/maven-springbeandoc-plugin
+#cp -pr mojo-sandbox/maven-springbeandoc-plugin/target/site/apidocs/* $RPM_BUILD_ROOT%{_javadocdir}/%{name}-%{version}/maven-springbeandoc-plugin
 
 install -d -m 755 $RPM_BUILD_ROOT%{_javadocdir}/%{name}-%{version}/maven-simple-plugin
 cp -pr mojo-sandbox/maven-plugin-testing/maven-simple-plugin/target/site/apidocs/* $RPM_BUILD_ROOT%{_javadocdir}/%{name}-%{version}/maven-simple-plugin
@@ -3662,7 +3675,7 @@
 cp -pr mojo-sandbox/springdoclet-maven-plugin/target/site/apidocs/* $RPM_BUILD_ROOT%{_javadocdir}/%{name}-%{version}/springdoclet-maven-plugin
 
 install -d -m 755 $RPM_BUILD_ROOT%{_javadocdir}/%{name}-%{version}/sysdeo-tomcat-maven-plugin
-cp -pr sysdeo-tomcat-maven-plugin/target/site/apidocs/* $RPM_BUILD_ROOT%{_javadocdir}/%{name}-%{version}/sysdeo-tomcat-maven-plugin
+#cp -pr sysdeo-tomcat-maven-plugin/target/site/apidocs/* $RPM_BUILD_ROOT%{_javadocdir}/%{name}-%{version}/sysdeo-tomcat-maven-plugin
 
 install -d -m 755 $RPM_BUILD_ROOT%{_javadocdir}/%{name}-%{version}/visibroker-maven-plugin
 cp -pr mojo-sandbox/visibroker-maven-plugin/target/site/apidocs/* $RPM_BUILD_ROOT%{_javadocdir}/%{name}-%{version}/visibroker-maven-plugin
@@ -3674,7 +3687,7 @@
 cp -pr mojo-sandbox/webdoclet-maven-plugin/target/site/apidocs/* $RPM_BUILD_ROOT%{_javadocdir}/%{name}-%{version}/webdoclet-maven-plugin
 
 install -d -m 755 $RPM_BUILD_ROOT%{_javadocdir}/%{name}-%{version}/xfire-maven-plugin
-cp -pr mojo-sandbox/xfire-maven-plugin/target/site/apidocs/* $RPM_BUILD_ROOT%{_javadocdir}/%{name}-%{version}/xfire-maven-plugin
+#cp -pr mojo-sandbox/xfire-maven-plugin/target/site/apidocs/* $RPM_BUILD_ROOT%{_javadocdir}/%{name}-%{version}/xfire-maven-plugin
 
 install -d -m 755 $RPM_BUILD_ROOT%{_javadocdir}/%{name}-%{version}/xjc-maven-plugin
 cp -pr mojo-sandbox/xjc-maven-plugin/target/site/apidocs/* $RPM_BUILD_ROOT%{_javadocdir}/%{name}-%{version}/xjc-maven-plugin
@@ -3695,16 +3708,16 @@
 cp -pr plugin-support/target/site/apidocs/* $RPM_BUILD_ROOT%{_javadocdir}/%{name}-%{version}/plugin-support
 
 install -d -m 755 $RPM_BUILD_ROOT%{_javadocdir}/%{name}-%{version}/retrotranslator-maven-plugin
-cp -pr retrotranslator-maven-plugin/target/site/apidocs/* $RPM_BUILD_ROOT%{_javadocdir}/%{name}-%{version}/retrotranslator-maven-plugin
+#cp -pr retrotranslator-maven-plugin/target/site/apidocs/* $RPM_BUILD_ROOT%{_javadocdir}/%{name}-%{version}/retrotranslator-maven-plugin
 
 install -d -m 755 $RPM_BUILD_ROOT%{_javadocdir}/%{name}-%{version}/sablecc-maven-plugin
 cp -pr sablecc-maven-plugin/target/site/apidocs/* $RPM_BUILD_ROOT%{_javadocdir}/%{name}-%{version}/sablecc-maven-plugin
 
 install -d -m 755 $RPM_BUILD_ROOT%{_javadocdir}/%{name}-%{version}/selenium-maven-plugin
-cp -pr selenium-maven-plugin/target/site/apidocs/* $RPM_BUILD_ROOT%{_javadocdir}/%{name}-%{version}/selenium-maven-plugin
+#cp -pr selenium-maven-plugin/target/site/apidocs/* $RPM_BUILD_ROOT%{_javadocdir}/%{name}-%{version}/selenium-maven-plugin
 
 install -d -m 755 $RPM_BUILD_ROOT%{_javadocdir}/%{name}-%{version}/shitty-maven-plugin
-cp -pr shitty-maven-plugin/target/site/apidocs/* $RPM_BUILD_ROOT%{_javadocdir}/%{name}-%{version}/shitty-maven-plugin
+#cp -pr shitty-maven-plugin/target/site/apidocs/* $RPM_BUILD_ROOT%{_javadocdir}/%{name}-%{version}/shitty-maven-plugin
 
 install -d -m 755 $RPM_BUILD_ROOT%{_javadocdir}/%{name}-%{version}/smc-maven-plugin
 cp -pr smc-maven-plugin/target/site/apidocs/* $RPM_BUILD_ROOT%{_javadocdir}/%{name}-%{version}/smc-maven-plugin
@@ -3719,7 +3732,7 @@
 cp -pr taglist-maven-plugin/target/site/apidocs/* $RPM_BUILD_ROOT%{_javadocdir}/%{name}-%{version}/taglist-maven-plugin
 
 install -d -m 755 $RPM_BUILD_ROOT%{_javadocdir}/%{name}-%{version}/tomcat-maven-plugin
-cp -pr tomcat-maven-plugin/target/site/apidocs/* $RPM_BUILD_ROOT%{_javadocdir}/%{name}-%{version}/tomcat-maven-plugin
+#cp -pr tomcat-maven-plugin/target/site/apidocs/* $RPM_BUILD_ROOT%{_javadocdir}/%{name}-%{version}/tomcat-maven-plugin
 
 install -d -m 755 $RPM_BUILD_ROOT%{_javadocdir}/%{name}-%{version}/webstart-pack200-jdk14
 cp -pr webstart/webstart-pack200-jdk14/target/site/apidocs/* $RPM_BUILD_ROOT%{_javadocdir}/%{name}-%{version}/webstart-pack200-jdk14
