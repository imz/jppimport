#!/usr/bin/perl -w

require 'set_without_extra.pl';
require 'set_add_jspapi_dep.pl';

push @SPECHOOKS, 
 sub {
    my ($jpp, $alt) = @_;
    $jpp->applied_block(
	'initdir hook',
	sub {
	    map {$_->subst(qr'%{_sysconfdir}/init.d','%{_initdir}')} $jpp->get_sections();
	});


# TODO: investigate problems with deps on xml-commons-apis.jar
# $jpp->get_section('package','')->unshift_body('%add_findreq_skiplist /usr/share/jetty5/ext/xml-commons-apis.jar'."\n");
# $jpp->get_section('package','')->unshift_body('%add_findreq_skiplist /usr/share/jetty5/ext/jspapi.jar'."\n");


# subst in jelly.init
#    daemon --user $JETTY_USER $JETTY_SCRIPT start
#    start_daemon --user $JETTY_USER $JETTY_SCRIPT
#    daemon --user $JETTY_USER $JETTY_SCRIPT stop
#    stop_daemon --user $JETTY_USER $JETTY_SCRIPT
# fixed -x functions; added condstop
    $jpp->copy_to_sources('jetty5.init');

    # remove explicit group ids
    $jpp->get_section('pre','')->subst_if(qr'-[gu]\s+%\{jtuid\}','-r',qr'add');
    # set default shell to /dev/null (will it work ?)
    $jpp->get_section('pre','')->subst(qr'-s /bin/sh','/dev/null');
    # hack to fix upgrade from -alt2 if rmuser/adduser to be applied
    #$jpp->get_section('post','')->push_body('chown -R %{name}.%{name} %logdir'."\n");

}
__END__

    $jpp->copy_to_sources('jetty-OSGi-MANIFEST.MF');
    $jpp->get_section('package','')->push_body('Source4:        jetty-OSGi-MANIFEST.MF'."\n");
    $jpp->get_section('build')->push_body('
# inject OSGi manifests
mkdir -p META-INF
cp %{SOURCE4} META-INF/MANIFEST.MF
zip -u lib/org.mortbay.jetty.jar META-INF/MANIFEST.MF
');


    $jpp->get_section('files','')->unshift_body('%{_mavendepmapfragdir}/*
%_datadir/maven2/poms/*'."\n");
    $jpp->get_section('install')->push_body(q&
%add_to_maven_depmap org.mortbay.jetty jetty %{version} JPP/jetty5 jetty5

mkdir -p $RPM_BUILD_ROOT/usr/share/maven2/poms/
cat > $RPM_BUILD_ROOT/usr/share/maven2/poms/JPP.jetty5-jetty5.pom << 'EOF'
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/maven-v4_0_0.xsd">
<--
  <parent>
    <artifactId>project</artifactId>
    <groupId>org.mortbay.jetty</groupId>
    <version>6.1.4</version>
    <relativePath>../../pom.xml</relativePath>
  </parent>
-->
  <modelVersion>4.0.0</modelVersion>
  <groupId>org.mortbay.jetty</groupId>
  <artifactId>jetty</artifactId>
  <name>Jetty Server</name>
  <url>http://jetty.mortbay.org</url>

  <name>Jetty Server Project</name>
  <version>5.1.12</version>
  <url>http://jetty.mortbay.org</url>
  <issueManagement>
    <system>jira</system>
    <url>http://jira.codehaus.org/browse/Jetty</url>
  </issueManagement>
  <mailingLists>
    <mailingList>
      <name>Jetty Discuss List</name>
      <archive>http://lists.sourceforge.net/lists/listinfo/jetty-discuss</archive>
      <otherArchives>
        <otherArchive>http://www.nabble.com/Jetty-Discuss-f60.html</otherArchive>
      </otherArchives>
    </mailingList>
    <mailingList>
      <name>Jetty Support List</name>
      <archive>http://lists.sourceforge.net/lists/listinfo/jetty-support</archive>
      <otherArchives>
        <otherArchive>http://www.nabble.com/Jetty-Support-f61.html</otherArchive>
      </otherArchives>
    </mailingList>
    <mailingList>
      <name>Jetty Announce List</name>
      <archive>http://lists.sourceforge.net/lists/listinfo/jetty-announce</archive>
      <otherArchives>
        <otherArchive>http://www.nabble.com/Jetty---Announce-f2649.html</otherArchive>
      </otherArchives>
    </mailingList>
  </mailingLists>
  <developers>
    <developer>
      <id>gregw</id>
      <name>Greg Wilkins</name>
      <email>gregw@apache.org</email>
      <url>http://www.mortbay.com/mortbay/people/gregw</url>
      <organization>Mort Bay Consulting</organization>
      <organizationUrl>http://www.mortbay.com</organizationUrl>
    </developer>
    <developer>
      <id>janb</id>
      <name>Jan Bartel</name>
      <email>janb@apache.org</email>
      <url>http://www.mortbay.com/people/janb</url>
      <organization>Mort Bay Consulting</organization>
      <organizationUrl>http://www.mortbay.com</organizationUrl>
    </developer>
    <developer>
      <id>jules</id>
      <name>Jules Gosnell</name>
      <email>jules@apache.org</email>
      <organization />
    </developer>
    <developer>
      <id>jstrachan</id>
      <name>James Strachan</name>
      <email>jstrachan@apache.org</email>
      <organization>Logic Blaze</organization>
      <organizationUrl>http://www.logicblaze.com</organizationUrl>
    </developer>
    <developer>
      <id>sbordet</id>
      <name>Simone Bordet</name>
      <email>simone.bordet@simulalabs.com</email>
      <organization>Simula Labs</organization>
      <organizationUrl>http://www.simulalabs.com</organizationUrl>
    </developer>
    <developer>
      <id>tvernum</id>
      <name>Tim Vernum</name>
      <email>tim@adjective.org</email>
      <organization />
    </developer>
    <developer>
      <id>ngonzalez</id>
      <name>Nik Gonzalez</name>
      <email>ngonzalez@exist.com</email>
      <organization />
    </developer>
    <developer>
      <id>jfarcand</id>
      <name>Jeanfrancois Arcand</name>
      <email>jfarcand@apache.org</email>
      <organization>Sun Microsystems</organization>
      <organizationUrl>http://www.sun.com</organizationUrl>
    </developer>
  </developers>
  <licenses>
    <license>
      <name>Apache License Version 2.0</name>
      <url>http://www.apache.org/licenses/LICENSE-2.0</url>
    </license>
  </licenses>
  <repositories>
   <repository>
    <id>codehaus.org</id>
    <name>Jetty snapshots</name>
    <layout>default</layout>
    <url>http://snapshots.repository.codehaus.org</url>
    <snapshots><enabled>true</enabled></snapshots>
   </repository>
  </repositories>
  <scm>
    <connection>scm:svn:https://svn.codehaus.org/jetty/jetty/trunk</connection>
    <developerConnection>scm:svn:https://svn.codehaus.org/jetty/jetty/trunk</developerConnection>
    <url>http://fisheye.codehaus.org/viewrep/jetty/</url>
  </scm>
  <organization>
    <name>Mort Bay Consulting</name>
    <url>http://www.mortbay.com</url>
  </organization>


  <dependencies>
    <dependency>
      <groupId>junit</groupId>
      <artifactId>junit</artifactId>
      <scope>test</scope>
    </dependency>
<--
    <dependency>
      <groupId>org.mortbay.jetty</groupId>
      <artifactId>jetty-util</artifactId>
      <version>${project.version}</version>
    </dependency>
    <dependency>
      <groupId>org.mortbay.jetty</groupId>
      <artifactId>servlet-api-2.5</artifactId>
      <version>${project.version}</version>
    </dependency>
-->
  </dependencies>
</project>
EOF
&);
