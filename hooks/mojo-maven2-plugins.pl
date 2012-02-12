#!/usr/bin/perl -w

sub _add_jar {
    my ($jpp, $exe) = @_;
    #$jpp->get_section('build')->unshift_body_after(qr'^export SETTINGS=',q!
    $jpp->get_section('build')->unshift_body_after(qr'^\%endif',q!
mvn-jpp -e \
    -s ${SETTINGS} \
    -Dmaven.repo.local=$MAVEN_REPO_LOCAL \
    -Dmaven.test.failure.ignore=true \
    -Dmaven2.jpp.depmap.file=%{SOURCE2} \
    !.$exe."\n");
}

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','-n mojo-maven2-plugin-antlr')->push_body('Provides: maven2-plugin-antlr = 2.0.4'."\n");

    $jpp->get_section('package','')->unshift_body('BuildRequires: geronimo-jpa-3.0-api javacc3 sun-ws-metadata-2.0-api sun-annotation-1.0-api'."\n");

    # pom dependency for newer findbugs plugin :(
    $jpp->get_section('package','-n mojo-maven2-plugin-findbugs')->push_body('Requires: mojo-parent'."\n");

    $jpp->get_section('install')->push_body(q{patch %buildroot/usr/share/maven2/poms/JPP.mojo-findbugs-maven-plugin.pom <<'EOF'
--- JPP.mojo-findbugs-maven-plugin.pom	2012-02-10 13:27:49.000000000 +0200
+++ JPP.mojo-findbugs-maven-plugin.pom	2012-02-11 19:02:04.000000000 +0200
@@ -135,11 +135,13 @@
       <artifactId>findbugs-ant</artifactId>
       <version>1.3.9</version>
     </dependency>
+    <!--
     <dependency>
       <groupId>jgoodies</groupId>
       <artifactId>plastic</artifactId>
       <version>1.2.0</version>
     </dependency>
+    -->
     <dependency>
       <groupId>org.codehaus.gmaven</groupId>
       <artifactId>gmaven-mojo</artifactId>
EOF
});

    $jpp->get_section('build')->subst_body(qr'"-Xmx512m"','"-Xmx640m -XX:MaxPermSize=256m"',qr'^export MAVEN_OPTS');

    $jpp->add_patch('mojo-maven2-plugins-17-alt-maven-wagon-a7-support.patch', STRIP=>0);#, NUMBER=>233);
    
    &_add_jar($jpp, 'install:install-file -DgroupId=easymock -DartifactId=easymock -Dversion=1.1 -Dpackaging=jar -Dfile=$(build-classpath easymock)');
    &_add_jar($jpp, 'install:install-file -DgroupId=org.eclipse.jdt.core.compiler -DartifactId=ecj -Dversion=3.3.1 -Dpackaging=jar -Dfile=$(build-classpath ecj)');

    $jpp->main_section->subst('dashboard_include 1','dashboard_include 0');
    $jpp->get_section('prep')->push_body(q{
sed -i 's,<module>dashboard-maven-plugin</module>,<!--2.0.8 nocompile<module>dashboard-maven-plugin</module>-->,' mojo-sandbox/pom.xml
});

    #[INFO] Compilation failure
    #/usr/src/RPM/BUILD/mojo-maven2-plugins-17/maven-extensions/wagon-cifs/src/main/java/org/apache/maven/wagon/providers/cifs/CifsWagon.java:[217,19] openConnectionInternal() is already defined in org.apache.maven.wagon.providers.cifs.CifsWagon
    $jpp->main_section->subst('wagon_cifs_include 1','wagon_cifs_include 0');
    $jpp->get_section('prep')->push_body(q{
sed -i 's,<module>wagon-cifs</module>,<!--tmp nocompile<module>wagon-cifs</module>-->,' maven-extensions/pom.xml
});

    # apache-ibatis2 -- not ready yet -- see what future releases require
#    $jpp->get_section('package','-n mojo-maven2-plugin-ibatis')->subst_body_if('apache-ibatis-abator-core','apache-ibatis2-ibator-core',qr'Requires:');
#    $jpp->get_section('prep')->push_body(q{# apache-ibatis2
#sed -i -e 's,Abatis,Ibatis,g;s,abatis,ibatis,g;s,Abator,Ibator,g;s,abator,ibator,g;' `grep -r -i -l abat mojo-sandbox/ibatis-maven-plugin/src`
#});
#    $jpp->source_apply_patch(PATCHFILE=>'mojo-maven2-plugins-jpp-depmap.xml-alt-use-ibatis2.patch',SOURCEFILE=>'mojo-maven2-plugins-jpp-depmap.xml');
    $jpp->main_section->subst('ibatis_include 1','ibatis_include 0');
    $jpp->get_section('prep')->push_body(q{
sed -i 's,<module>ibatis-maven-plugin</module>,<!--tmp nocompile<module>ibatis-maven-plugin</module>-->,' mojo-sandbox/pom.xml
});

    # dropped xfire
    $jpp->main_section->subst('xfire_include 1','xfire_include 0');
    $jpp->get_section('prep')->push_body(q{
sed -i 's,<module>xfire-maven-plugin</module>,<!--tmp nocompile<module>xfire-maven-plugin</module>-->,' mojo-sandbox/pom.xml
});

    # poi25 pom resolution
    $jpp->source_apply_patch(PATCHFILE=>'mojo-maven2-plugins-jpp-depmap.xml-alt-use-poi25.patch',SOURCEFILE=>'mojo-maven2-plugins-jpp-depmap.xml');
};

__END__

    $_="# hack: use old modello10 instead of providing model for new modello, see messages
[INFO] One or more required plugin parameters are invalid/missing for 'modello:java'
[0] Inside the definition for plugin 'modello-maven-plugin' specify the following:
<configuration>
  ...
  <models>VALUE</models>
</configuration>.
    ";
	$jpp->applied_block(
	"use old modello10 hook",
	sub {
	    foreach my $sec ($jpp->get_sections) {
		next if $sec->get_type ne 'package';
		$sec->subst_if(qr'modello-maven-plugin','modello10','^BuildRequires:');
		$sec->subst_if(qr'modello(?!10)','modello10','^BuildRequires:');
	    }
	}
	);



# done in -8 & -9
    $jpp->main_section->subst('xdoclet_include 1','xdoclet_include 0');
sed -i 's,<module>xdoclet-maven-plugin</module>,<!-- module>xdoclet-maven-plugin</module -->,' pom.xml
