#!/usr/bin/perl -w

require 'set_without_extra.pl';
require 'set_add_jspapi_dep.pl';
require 'set_fix_homedir_macro.pl';

$spechook = sub {
    my ($jpp, $alt) = @_;
    map {$_->subst(qr'%{_sysconfdir}/init.d','%{_initdir}')} @{$jpp->get_sections()};

# TODO: investigate problems with deps on xml-commons-apis.jar
    $jpp->get_section('package','')->unshift_body('%add_findreq_skiplist /usr/share/jetty5/ext/xml-commons-apis.jar'."\n");
    $jpp->get_section('package','')->unshift_body('%add_findreq_skiplist /usr/share/jetty5/ext/jspapi.jar'."\n");


# # TODO: subst in jelly.init
#    daemon --user $JETTY_USER $JETTY_SCRIPT start
#    start_daemon --user $JETTY_USER $JETTY_SCRIPT
#    daemon --user $JETTY_USER $JETTY_SCRIPT stop
#    stop_daemon --user $JETTY_USER $JETTY_SCRIPT
    $jpp->copy_to_sources('jetty5.init');

    $jpp->copy_to_sources('jetty-OSGi-MANIFEST.MF');
    $jpp->get_section('package','')->push_body('Source4:        jetty-OSGi-MANIFEST.MF'."\n");
    $jpp->get_section('build')->push_body('
# inject OSGi manifests
mkdir -p META-INF
cp %{SOURCE4} META-INF/MANIFEST.MF
zip -u lib/org.mortbay.jetty.jar META-INF/MANIFEST.MF
');

    # remove explicit group ids
    $jpp->get_section('pre','')->subst_if(qr'-[gu]\s+%\{jtuid\}','',qr'add');
    #-s /bin/sh?
    #$jpp->get_section('pre','')->subst_if(qr'-s /bin/sh','/bin/false',qr'add');
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


}
__END__
%add_to_maven_depmap org.mortbay.jetty project %{version} JPP/jetty6 project
%add_to_maven_depmap org.mortbay.jetty jetty %{version} JPP/jetty6 jetty6
%add_to_maven_depmap org.mortbay.jetty jetty-html %{version} JPP/jetty6 jetty6-html
%add_to_maven_depmap org.mortbay.jetty jetty-util %{version} JPP/jetty6 jetty6-util
%add_to_maven_depmap org.mortbay.jetty jetty-naming %{version} JPP/jetty6 jetty6-naming
%add_to_maven_depmap org.mortbay.jetty jetty-management %{version} JPP/jetty6 jetty6-management
%add_to_maven_depmap org.mortbay.jetty jetty-plus %{version} JPP/jetty6 jetty6-plus
%add_to_maven_depmap org.mortbay.jetty servlet-api-2.5 %{version} JPP jetty6-servlet-2.5-api
%add_to_maven_depmap org.mortbay.jetty jsp-api-2.0 %{version} JPP jetty6-jsp-2.0-api
%add_to_maven_depmap org.mortbay.jetty jsp-2.0 %{version} JPP/jetty6 jsp-2.0

<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/maven-v4_0_0.xsd">
  <modelVersion>4.0.0</modelVersion>
  <groupId>org.mortbay.jetty</groupId>
  <artifactId>project</artifactId>
  <packaging>pom</packaging>
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
  <build>
    <sourceDirectory>src/main/java</sourceDirectory>
    <scriptSourceDirectory>src/main/scripts</scriptSourceDirectory>
    <testSourceDirectory>src/test/java</testSourceDirectory>
    <outputDirectory>target/classes</outputDirectory>
    <testOutputDirectory>target/test-classes</testOutputDirectory>
    <extensions>
      <extension>
        <groupId>org.apache.maven.wagon</groupId>
        <artifactId>wagon-ssh-external</artifactId>
        <version>1.0-alpha-6</version>
      </extension>
      <extension>
	<groupId>org.apache.maven.wagon</groupId>
	<artifactId>wagon-webdav</artifactId>
	<version>1.0-beta-1</version>
      </extension>
    </extensions>
    <defaultGoal>install</defaultGoal>
    <resources>
      <resource>
        <directory>src/main/resources</directory>
      </resource>
    </resources>
    <testResources>
      <testResource>
        <directory>src/test/resources</directory>
      </testResource>
    </testResources>
    <directory>target</directory>
    <finalName>${artifactId}-${version}</finalName>
    <plugins>
      <plugin>
        <artifactId>maven-compiler-plugin</artifactId>
        <configuration>
          <source>1.4</source>
          <target>1.4</target>
        </configuration>
      </plugin>
      <plugin>
        <artifactId>maven-release-plugin</artifactId>
        <configuration>
          <tagBase>https://svn.codehaus.org/jetty/jetty/tags</tagBase>
        </configuration>
      </plugin>

      <plugin>
        <groupId>org.apache.maven.plugins</groupId>
        <artifactId>maven-jar-plugin</artifactId>
        <version>2.1</version>
        <configuration>
          <archive>
            <manifestEntries>
              <mode>development</mode>
              <url>${pom.url}</url>
	      <package>org.mortbay</package>
            </manifestEntries>
          </archive>
        </configuration>
      </plugin>

      <plugin>
	<inherited>true</inherited>
	<groupId>org.apache.maven.plugins</groupId>
	<artifactId>maven-source-plugin</artifactId>
	<executions>
	  <execution>
	    <id>attach-sources</id>
	    <goals>
	      <goal>jar</goal>
	    </goals>
	  </execution>
	</executions>
      </plugin>
    </plugins>
  </build>
  <modules>
    <module>modules/jetty</module>
  </modules>

  <reporting>
    <outputDirectory>target/site</outputDirectory>
    <plugins>
      <plugin>
        <groupId>org.apache.maven.plugins</groupId>
        <artifactId>maven-javadoc-plugin</artifactId>
          <configuration>
            <aggregate>true</aggregate>
            <debug>true</debug>
            <stylesheetfile>${basedir}/project-website/project-site/src/resources/javadoc.css</stylesheetfile>
            <links>
              <link>http://java.sun.com/javaee/5/docs/api</link>
              <link>http://java.sun.com/j2se/1.5.0/docs/api</link>
            </links>
          </configuration>
      </plugin>
      <plugin>
        <groupId>org.apache.maven.plugins</groupId>
        <artifactId>maven-jxr-plugin</artifactId>
        <configuration>
          <aggregate>true</aggregate>
       </configuration>
      </plugin>
      <plugin>
        <groupId>org.apache.maven.plugins</groupId>
        <artifactId>maven-project-info-reports-plugin</artifactId>
        <reportSets>
          <reportSet>
            <reports>
              <report>project-team</report>
            </reports>
          </reportSet>
        </reportSets>
      </plugin>
      <plugin>
        <groupId>org.apache.maven.plugins</groupId>
        <artifactId>maven-clover-plugin</artifactId>
        <configuration>
        </configuration>
      </plugin>
    </plugins>
  </reporting>
  <dependencyManagement>
    <dependencies>
      <dependency>
        <groupId>org.apache.maven</groupId>
        <artifactId>maven-plugin-tools-api</artifactId>
        <version>2.0</version>
      </dependency>
      <dependency>
        <groupId>junit</groupId>
        <artifactId>junit</artifactId>
        <version>${junit-version}</version>
      </dependency>
<--
      <dependency>
        <groupId>org.slf4j</groupId>
        <artifactId>jcl104-over-slf4j</artifactId>
        <version>${slf4j-version}</version>
      </dependency>
      <dependency>
        <groupId>org.slf4j</groupId>
        <artifactId>slf4j-simple</artifactId>
        <version>${slf4j-version}</version>
      </dependency>
      <dependency>
        <groupId>mx4j</groupId>
        <artifactId>mx4j</artifactId>
        <version>${mx4j-version}</version>
      </dependency>
      <dependency>
        <groupId>mx4j</groupId>
        <artifactId>mx4j-tools</artifactId>
        <version>${mx4j-version}</version>
      </dependency>
      <dependency>
        <groupId>xerces</groupId>
        <artifactId>xercesImpl</artifactId>
        <version>${xerces-version}</version>
      </dependency>
      <dependency>
        <groupId>commons-el</groupId>
        <artifactId>commons-el</artifactId>
        <version>${commons-el-version}</version>
      </dependency>
      <dependency>
        <groupId>ant</groupId>
        <artifactId>ant</artifactId>
        <version>${ant-version}</version>
      </dependency>
      <dependency>
        <groupId>javax.mail</groupId>
        <artifactId>mail</artifactId>
        <version>${mail-version}</version>
      </dependency>
      <dependency>
        <groupId>javax.activation</groupId>
        <artifactId>activation</artifactId>
        <version>${activation-version}</version>
      </dependency>
-->
    </dependencies>
  </dependencyManagement>
  <distributionManagement>
    <repository>
      <id>codehaus.org</id>
      <name>Jetty Repository</name>
      <url>dav:https://dav.codehaus.org/repository/jetty/</url>
    </repository>
    <snapshotRepository>
      <id>codehaus.org</id>
      <name>Jetty Snapshot Repository</name>
      <url>dav:https://dav.codehaus.org/snapshots.repository/jetty/</url>
    </snapshotRepository>
    <site>
      <id>codehaus.org</id>
      <url>dav:https://dav.codehaus.org/jetty/</url>
    </site>
  </distributionManagement>
</project>







<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/maven-v4_0_0.xsd">
  <modelVersion>4.0.0</modelVersion>
  <groupId>org.mortbay.jetty</groupId>
  <artifactId>project</artifactId>
  <packaging>pom</packaging>
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
  <build>
    <sourceDirectory>src/main/java</sourceDirectory>
    <scriptSourceDirectory>src/main/scripts</scriptSourceDirectory>
    <testSourceDirectory>src/test/java</testSourceDirectory>
    <outputDirectory>target/classes</outputDirectory>
    <testOutputDirectory>target/test-classes</testOutputDirectory>
    <extensions>
      <extension>
        <groupId>org.apache.maven.wagon</groupId>
        <artifactId>wagon-ssh-external</artifactId>
        <version>1.0-alpha-6</version>
      </extension>
      <extension>
	<groupId>org.apache.maven.wagon</groupId>
	<artifactId>wagon-webdav</artifactId>
	<version>1.0-beta-1</version>
      </extension>
    </extensions>
    <defaultGoal>install</defaultGoal>
    <resources>
      <resource>
        <directory>src/main/resources</directory>
      </resource>
    </resources>
    <testResources>
      <testResource>
        <directory>src/test/resources</directory>
      </testResource>
    </testResources>
    <directory>target</directory>
    <finalName>${artifactId}-${version}</finalName>
    <plugins>
      <plugin>
        <artifactId>maven-compiler-plugin</artifactId>
        <configuration>
          <source>1.4</source>
          <target>1.4</target>
        </configuration>
      </plugin>
      <plugin>
        <artifactId>maven-release-plugin</artifactId>
        <configuration>
          <tagBase>https://svn.codehaus.org/jetty/jetty/tags</tagBase>
        </configuration>
      </plugin>

      <plugin>
        <groupId>org.apache.maven.plugins</groupId>
        <artifactId>maven-jar-plugin</artifactId>
        <version>2.1</version>
        <configuration>
          <archive>
            <manifestEntries>
              <mode>development</mode>
              <url>${pom.url}</url>
	      <package>org.mortbay</package>
            </manifestEntries>
          </archive>
        </configuration>
      </plugin>

      <plugin>
	<inherited>true</inherited>
	<groupId>org.apache.maven.plugins</groupId>
	<artifactId>maven-source-plugin</artifactId>
	<executions>
	  <execution>
	    <id>attach-sources</id>
	    <goals>
	      <goal>jar</goal>
	    </goals>
	  </execution>
	</executions>
      </plugin>
    </plugins>
  </build>
  <modules>
    <module>modules/jetty</module>
  </modules>

  <reporting>
    <outputDirectory>target/site</outputDirectory>
    <plugins>
      <plugin>
        <groupId>org.apache.maven.plugins</groupId>
        <artifactId>maven-javadoc-plugin</artifactId>
          <configuration>
            <aggregate>true</aggregate>
            <debug>true</debug>
            <stylesheetfile>${basedir}/project-website/project-site/src/resources/javadoc.css</stylesheetfile>
            <links>
              <link>http://java.sun.com/javaee/5/docs/api</link>
              <link>http://java.sun.com/j2se/1.5.0/docs/api</link>
            </links>
          </configuration>
      </plugin>
      <plugin>
        <groupId>org.apache.maven.plugins</groupId>
        <artifactId>maven-jxr-plugin</artifactId>
        <configuration>
          <aggregate>true</aggregate>
       </configuration>
      </plugin>
      <plugin>
        <groupId>org.apache.maven.plugins</groupId>
        <artifactId>maven-project-info-reports-plugin</artifactId>
        <reportSets>
          <reportSet>
            <reports>
              <report>project-team</report>
            </reports>
          </reportSet>
        </reportSets>
      </plugin>
      <plugin>
        <groupId>org.apache.maven.plugins</groupId>
        <artifactId>maven-clover-plugin</artifactId>
        <configuration>
        </configuration>
      </plugin>
    </plugins>
  </reporting>
  <dependencyManagement>
    <dependencies>
      <dependency>
        <groupId>org.apache.maven</groupId>
        <artifactId>maven-plugin-tools-api</artifactId>
        <version>2.0</version>
      </dependency>
      <dependency>
        <groupId>junit</groupId>
        <artifactId>junit</artifactId>
        <version>${junit-version}</version>
      </dependency>
<--
      <dependency>
        <groupId>org.slf4j</groupId>
        <artifactId>jcl104-over-slf4j</artifactId>
        <version>${slf4j-version}</version>
      </dependency>
      <dependency>
        <groupId>org.slf4j</groupId>
        <artifactId>slf4j-simple</artifactId>
        <version>${slf4j-version}</version>
      </dependency>
      <dependency>
        <groupId>mx4j</groupId>
        <artifactId>mx4j</artifactId>
        <version>${mx4j-version}</version>
      </dependency>
      <dependency>
        <groupId>mx4j</groupId>
        <artifactId>mx4j-tools</artifactId>
        <version>${mx4j-version}</version>
      </dependency>
      <dependency>
        <groupId>xerces</groupId>
        <artifactId>xercesImpl</artifactId>
        <version>${xerces-version}</version>
      </dependency>
      <dependency>
        <groupId>commons-el</groupId>
        <artifactId>commons-el</artifactId>
        <version>${commons-el-version}</version>
      </dependency>
      <dependency>
        <groupId>ant</groupId>
        <artifactId>ant</artifactId>
        <version>${ant-version}</version>
      </dependency>
      <dependency>
        <groupId>javax.mail</groupId>
        <artifactId>mail</artifactId>
        <version>${mail-version}</version>
      </dependency>
      <dependency>
        <groupId>javax.activation</groupId>
        <artifactId>activation</artifactId>
        <version>${activation-version}</version>
      </dependency>
-->
    </dependencies>
  </dependencyManagement>
  <distributionManagement>
    <repository>
      <id>codehaus.org</id>
      <name>Jetty Repository</name>
      <url>dav:https://dav.codehaus.org/repository/jetty/</url>
    </repository>
    <snapshotRepository>
      <id>codehaus.org</id>
      <name>Jetty Snapshot Repository</name>
      <url>dav:https://dav.codehaus.org/snapshots.repository/jetty/</url>
    </snapshotRepository>
    <site>
      <id>codehaus.org</id>
      <url>dav:https://dav.codehaus.org/jetty/</url>
    </site>
  </distributionManagement>
</project>


