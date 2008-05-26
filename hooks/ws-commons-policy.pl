#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('BuildRequires: servletapi4 apache-axiom'."\n");
    $jpp->get_section('prep')->push_body(q!
cat project.xml | grep -v '<name>WS-Policy Implementation</name>' > project.xml.0
mv project.xml.0 project.xml
!);

};

__END__
# TODO:
#http://mail-archives.apache.org/mod_mbox/ws-axis-dev/200609.mbox/%3Cf43ea5790609141335m292b0b9chcbbaf0007e829a23@mail.gmail.com%3E
#Hmmm...
#We have no class called org.apache.axis2.om.OMElement anymore. The
#packaging has changed and it is called org.apache.axiom.om.OMElement
#now. Are you having an older aar file ?

# I did it myself :(
#find . -name '*.java' -type f -exec subst s,org.apache.wsdl,org.apache.axis2.wsdl, {} \;
#find . -name '*.java' -type f -exec subst s,org.apache.axis2.om,org.apache.axiom.om, {} \;
#find . -name '*.java' -type f -exec subst s,org.apache.axis2.wsdl.builder,org.apache.axis2.builder, {} \;

## hacked depmap piece
<dependencies>
	<dependency>
		<maven>
			<groupId>axis2</groupId>
			<artifactId>axis2-xml</artifactId>
			<version>${axis2.version}</version>
		</maven>
		<jpp>
			<groupId>JPP</groupId>
			<artifactId>axis2-xml</artifactId>
			<jar>axis2/xmlbeans.jar</jar>
			<version>${axis2.version}</version>
		</jpp>
	</dependency>

	<dependency>
		<maven>
			<groupId>axis2</groupId>
			<artifactId>axis2-wsdl</artifactId>
			<version>${axis2.version}</version>
		</maven>
		<jpp>
			<groupId>JPP</groupId>
			<artifactId>axis2-wsdl</artifactId>
			<jar>axis2/java2wsdl.jar</jar>
			<version>${axis2.version}</version>
		</jpp>
	</dependency>

############ even worse hacked generated project.pom
# the my add-ons
      <dependency>
         <groupId>JPP</groupId>
         <artifactId>ws-commons-axiom</artifactId>
         <jar>ws-commons-axiom.jar</jar>
         <version>1.2.4</version>
      </dependency>
      <dependency>
         <groupId>JPP</groupId>
         <artifactId>axis2-core</artifactId>
         <jar>axis2/core.jar</jar>
         <version>${axis2.version}</version>
      </dependency>
### the whole poo
<?xml version="1.0" encoding="utf-8"?>
<project>
   <pomVersion>3</pomVersion>
   <name>Web Services Commons : WS-Policy implemenation</name>
   <id>ws-policy</id>
   <groupId>ws-commons</groupId>
   <currentVersion>1.0</currentVersion>
   <organization>
      <name>Apache Software Foundation</name>
      <url>http://www.apache.org/</url>
   </organization>
   <inceptionYear>2002</inceptionYear>
   <package>org.apache.policy</package>
   <mailingLists/>
   <developers/>
   <build>
      <nagEmailAddress>general@ws.apache.org</nagEmailAddress>
      <sourceDirectory>src</sourceDirectory>
   </build>
   <dependencies>
      <dependency>
         <groupId>JPP</groupId>
         <artifactId>axis2-xml</artifactId>
         <jar>axis2/xmlbeans.jar</jar>
         <version>${axis2.version}</version>
      </dependency>
      <dependency>
         <groupId>JPP</groupId>
         <artifactId>axis2-wsdl</artifactId>
         <jar>axis2/java2wsdl.jar</jar>
         <version>${axis2.version}</version>
      </dependency>
      <dependency>
         <groupId>JPP</groupId>
         <artifactId>${stax.impl.artifactid}</artifactId>
         <jar>bea-stax-ri.jar</jar>
         <version>${stax.impl.version}</version>
         <properties>
            <module>true</module>
         </properties>
      </dependency>
      <dependency>
         <groupId>JPP</groupId>
         <artifactId>stax-api</artifactId>
         <jar>bea-stax-api.jar</jar>
         <version>${stax.api.version}</version>
         <properties>
            <module>true</module>
         </properties>
      </dependency>
      <dependency>
         <groupId>JPP</groupId>
         <artifactId>wsdl4j</artifactId>
         <jar>wsdl4j.jar</jar>
         <version>${axis.wsdl4j.version}</version>
         <properties>
            <module>true</module>
         </properties>
      </dependency>
      <dependency>
         <groupId>JPP</groupId>
         <artifactId>commons-logging</artifactId>
         <jar>commons-logging.jar</jar>
         <version>${commons.logging.version}</version>
         <properties>
            <module>true</module>
         </properties>
      </dependency>
      <dependency>
         <groupId>JPP</groupId>
         <artifactId>ws-commons-axiom</artifactId>
         <jar>ws-commons-axiom.jar</jar>
         <version>1.2.4</version>
      </dependency>
      <dependency>
         <groupId>JPP</groupId>
         <artifactId>axis2-core</artifactId>
         <jar>axis2/core.jar</jar>
         <version>${axis2.version}</version>
      </dependency>
   </dependencies>
</project>
