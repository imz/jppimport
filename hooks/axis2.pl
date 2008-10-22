#!/usr/bin/perl -w

#require 'set_target_14.pl';

push @SPECHOOKS, 

sub {
    my ($jpp, $alt) = @_;
    # it looks like circular dependency; we need bootstrap first
#    $jpp->get_section('package','')->unshift_body('BuildRequires: axis2'."\n");

    # 1.7 stuff: test and remove
    #----------------------------------
    $jpp->get_section('package','')->unshift_body('BuildRequires: maven-shared-plugin-testing-harness mojo-maven2-plugin-build-helper excalibur-avalon-framework'."\n");
    # it requires jaxb: try JaxMe
    $jpp->get_section('package','')->unshift_body('BuildRequires: ws-jaxme'."\n");

}

__END__
note: w/o axis2 dep...
still need maven-shared
> jar cf $MAVEN_REPO_LOCAL/org.apache.axis2/axis2-saaj-api.jar dummy
> jar cf $MAVEN_REPO_LOCAL/org.apache.axis2/axis2-jaxws-api.jar dummy
> jar cf $MAVEN_REPO_LOCAL/org.apache.axis2/axis2-saaj.jar dummy
> jar cf $MAVEN_REPO_LOCAL/org.apache.axis2/axis2-jaxws.jar dummy
> jar cf $MAVEN_REPO_LOCAL/org.apache.axis2/axis2-metadata.jar dummy

or 
mvn-jpp -e \
        -s ${MAVEN_SETTINGS} \
        -Dmaven2.jpp.mode=true \
        -Dmaven2.jpp.depmap.file=%{SOURCE2} \
        -Dmaven.repo.local=$MAVEN_REPO_LOCAL \
        install:install-file -DgroupId=org.apache.axis2 \
        -DartifactId=axis2-xmlbeans \ 
        -Dversion=1.2 -Dpackaging=jar \
        -Dfile=$(build-classpath axis2/xmlbeans.jar)


1.7
# TODO: diff is not mentioned in spec
  <dependency>
	<maven>
	  <groupId>com.sun.xml.bind</groupId>
	  <artifactId>jaxb-impl</artifactId>
	  <version>${jaxb-impl.version}</version>
	</maven>
	<jpp>
	  <groupId>JPP</groupId>
	  <artifactId>jaxme/jaxme2</artifactId>
	  <version>0.5.2</version>
	</jpp>
  </dependency>

  <dependency>
	<maven>
	  <groupId>javax.xml.bind</groupId>
	  <artifactId>jaxb-api</artifactId>
	  <version>${jaxb-api.version}</version>
	</maven>
	<jpp>
	  <groupId>JPP</groupId>
	  <artifactId>jaxme/jaxmeapi</artifactId>
	  <version>0.5.2</version>
	</jpp>
  </dependency>

  <dependency>
	<maven>
	  <groupId>com.sun.xml.bind</groupId>
	  <artifactId>jaxb-xjc</artifactId>
	  <version>${jaxb-xjc.version}</version>
	</maven>
	<jpp>
	  <groupId>JPP</groupId>
	  <artifactId>jaxme/jaxmexs</artifactId>
	  <version>0.5.2</version>
	</jpp>
  </dependency>

  <dependency>
	<maven>
	  <groupId>org.apache.axis2</groupId>
	  <artifactId>axis2-saaj</artifactId>
	  <version>${axis2-saaj.version}</version>
	</maven>
	<jpp>
	  <groupId>JPP</groupId>
	  <artifactId>axis/saaj</artifactId>
	  <version>1.4</version>
	</jpp>
  </dependency>

  <dependency>
	<maven>
	  <groupId>org.apache.axis2</groupId>
	  <artifactId>axis2-saaj-api</artifactId>
	  <version>${axis2-saaj-api.version}</version>
	</maven>
	<jpp>
	  <groupId>JPP</groupId>
	  <artifactId>axis/saaj</artifactId>
	  <version>1.4</version>
	</jpp>
  </dependency>
# the whole axis2-maven2-jpp-depmap.xml
<dependencies>
  <dependency>
	<maven>
	  <groupId>stax</groupId>
	  <artifactId>stax-api</artifactId>
	  <version>${stax.api.version}</version>
	</maven>
	<jpp>
	  <groupId>JPP</groupId>
	  <artifactId>bea-stax-api</artifactId>
	  <version>1.2.0</version>
	</jpp>
  </dependency>

  <dependency>
	<maven>
	  <groupId>org.apache.ant</groupId>
	  <artifactId>ant</artifactId>
	  <version>${ant.version}</version>
	</maven>
	<jpp>
	  <groupId>JPP</groupId>
	  <artifactId>ant</artifactId>
	  <version>1.6.5</version>
	</jpp>
  </dependency>

  <dependency>
	<maven>
	  <groupId>org.apache.ws.commons.axiom</groupId>
	  <artifactId>axiom-api</artifactId>
	  <version>${axiom.version}</version>
	</maven>
	<jpp>
	  <groupId>JPP</groupId>
	  <artifactId>ws-commons-axiom-api</artifactId>
	  <version>${axiom.version}</version>
	</jpp>
  </dependency>

  <dependency>
	<maven>
	  <groupId>org.apache.ws.commons.axiom</groupId>
	  <artifactId>axiom-impl</artifactId>
	  <version>${axiom.version}</version>
	</maven>
	<jpp>
	  <groupId>JPP</groupId>
	  <artifactId>ws-commons-axiom-impl</artifactId>
	  <version>${axiom.version}</version>
	</jpp>
  </dependency>

  <dependency>
	<maven>
	  <groupId>annogen</groupId>
	  <artifactId>annogen</artifactId>
	  <version>${annogen.version}</version>
	</maven>
	<jpp>
	  <groupId>JPP</groupId>
	  <artifactId>annogen</artifactId>
	  <version>${annogen.version}</version>
	</jpp>
  </dependency>

  <dependency>
	<maven>
	  <groupId>backport-util-concurrent</groupId>
	  <artifactId>backport-util-concurrent</artifactId>
	  <version>${backport.util.concurrent.version}</version>
	</maven>
	<jpp>
	  <groupId>JPP</groupId>
	  <artifactId>backport-util-concurrent</artifactId>
	  <version>${backport.util.concurrent.version}</version>
	</jpp>
  </dependency>

  <dependency>
	<maven>
	  <groupId>commons-fileupload</groupId>
	  <artifactId>commons-fileupload</artifactId>
	  <version>${commons.fileupload.version}</version>
	</maven>
	<jpp>
	  <groupId>JPP</groupId>
	  <artifactId>commons-fileupload</artifactId>
	  <version>${commons.fileupload.version}</version>
	</jpp>
  </dependency>

  <dependency>
	<maven>
	  <groupId>org.apache.httpcomponents</groupId>
	  <artifactId>jakarta-httpcore</artifactId>
	  <version>${jakarta.httpcore.version}</version>
	</maven>
	<jpp>
	  <groupId>JPP</groupId>
	  <artifactId>jakarta-httpcore</artifactId>
	  <version>${jakarta.httpcore.version}</version>
	</jpp>
  </dependency>

  <dependency>
	<maven>
	  <groupId>xmlunit</groupId>
	  <artifactId>xmlunit</artifactId>
	  <version>${xmlunit.version}</version>
	</maven>
	<jpp>
	  <groupId>JPP</groupId>
	  <artifactId>xmlunit</artifactId>
	  <version>${xmlunit.version}</version>
	</jpp>
  </dependency>

  <dependency>
	<maven>
	  <groupId>xmlbeans</groupId>
	  <artifactId>xbean</artifactId>
	  <version>${xbean.version}</version>
	</maven>
	<jpp>
	  <groupId>JPP/xmlbeans</groupId>
	  <artifactId>xbean</artifactId>
	  <version>${xbean.version}</version>
	</jpp>
  </dependency>

  <dependency>
	<maven>
	  <groupId>xpp3</groupId>
	  <artifactId>xpp3</artifactId>
	  <version>1.1.3.4.O</version>
	</maven>
	<jpp>
	  <groupId>JPP</groupId>
	  <artifactId>xpp3</artifactId>
	  <version>1.1.3.4.O</version>
	</jpp>
  </dependency>

  <dependency>
	<maven>
	  <groupId>bcel</groupId>
	  <artifactId>bcel</artifactId>
	  <version>${bcel.version}</version>
	</maven>
	<jpp>
	  <groupId>JPP</groupId>
	  <artifactId>bcel</artifactId>
	  <version>${bcel.version}</version>
	</jpp>
  </dependency>

  <dependency>
	<maven>
	  <groupId>org.apache.bcel</groupId>
	  <artifactId>bcel</artifactId>
	  <version>${bcel.version}</version>
	</maven>
	<jpp>
	  <groupId>JPP</groupId>
	  <artifactId>bcel</artifactId>
	  <version>${bcel.version}</version>
	</jpp>
  </dependency>

  <dependency>
	<maven>
	  <groupId>org.apache.ant</groupId>
	  <artifactId>ant-launcher</artifactId>
	  <version>${ant.version}</version>
	</maven>
	<jpp>
	  <groupId>JPP</groupId>
	  <artifactId>ant-launcher</artifactId>
	  <version>${ant.version}</version>
	</jpp>
  </dependency>

  <dependency>
	<maven>
	  <groupId>org.springframework</groupId>
	  <artifactId>spring-beans</artifactId>
	  <version>${spring.version}</version>
	</maven>
	<jpp>
	  <groupId>JPP/spring</groupId>
	  <artifactId>beans</artifactId>
	  <version>${spring.version}</version>
	</jpp>
  </dependency>
  <dependency>
	<maven>
	  <groupId>org.springframework</groupId>
	  <artifactId>spring-context</artifactId>
	  <version>${spring.version}</version>
	</maven>
	<jpp>
	  <groupId>JPP/spring</groupId>
	  <artifactId>context</artifactId>
	  <version>${spring.version}</version>
	</jpp>
  </dependency>
  <dependency>
	<maven>
	  <groupId>org.springframework</groupId>
	  <artifactId>spring-core</artifactId>
	  <version>${spring.version}</version>
	</maven>
	<jpp>
	  <groupId>JPP/spring</groupId>
	  <artifactId>core</artifactId>
	  <version>${spring.version}</version>
	</jpp>
  </dependency>
  <dependency>
	<maven>
	  <groupId>org.springframework</groupId>
	  <artifactId>spring-web</artifactId>
	  <version>${spring.version}</version>
	</maven>
	<jpp>
	  <groupId>JPP/spring</groupId>
	  <artifactId>web</artifactId>
	  <version>${spring.version}</version>
	</jpp>
  </dependency>

  <dependency>
	<maven>
	  <groupId>servletapi</groupId>
	  <artifactId>servletapi</artifactId>
	  <version>${servlet.api.version}</version>
	</maven>
	<jpp>
	  <groupId>JPP</groupId>
	  <artifactId>servletapi4</artifactId>
	  <version>${servlet.api.version}</version>
	</jpp>
  </dependency>

  <dependency>
	<maven>
	  <groupId>org.eclipse.ui</groupId>
	  <artifactId>org.eclipse.ui.workbench</artifactId>
	  <version>${eclipse.version}</version>
	</maven>
	<jpp>
	  <groupId>ECLIPSE</groupId>
	  <artifactId>org.eclipse.ui.workbench</artifactId>
	  <version>${eclipse.version}</version>
	</jpp>
  </dependency>
  <dependency>
	<maven>
	  <groupId>org.eclipse.ui</groupId>
	  <artifactId>org.eclipse.ui.ide</artifactId>
	  <version>${eclipse.version}</version>
	</maven>
	<jpp>
	  <groupId>ECLIPSE</groupId>
	  <artifactId>org.eclipse.ui.ide</artifactId>
	  <version>${eclipse.version}</version>
	</jpp>
  </dependency>
  <dependency>
	<maven>
	  <groupId>org.eclipse.equinox</groupId>
	  <artifactId>org.eclipse.equinox.common</artifactId>
	  <version>${eclipse.version}</version>
	</maven>
	<jpp>
	  <groupId>ECLIPSE</groupId>
	  <artifactId>org.eclipse.equinox.common</artifactId>
	  <version>${eclipse.version}</version>
	</jpp>
  </dependency>
  <dependency>
	<maven>
	  <groupId>org.eclipse.swt</groupId>
	  <artifactId>org.eclipse.swt</artifactId>
	  <version>${eclipse.version}</version>
	</maven>
	<jpp>
	  <groupId>ECLIPSE</groupId>
	  <artifactId>org.eclipse.swt</artifactId>
	  <version>${eclipse.version}</version>
	</jpp>
  </dependency>
  <dependency>
	<maven>
	  <groupId>org.eclipse.swt</groupId>
	  <artifactId>org.eclipse.swt.win32.win32.x86</artifactId>
	  <version>${eclipse.version}</version>
	</maven>
	<jpp>
	  <groupId>ECLIPSE</groupId>
	  <artifactId>org.eclipse.swt.arch</artifactId>
	  <version>${eclipse.version}</version>
	</jpp>
  </dependency>
  <dependency>
	<maven>
	  <groupId>org.eclipse.osgi</groupId>
	  <artifactId>org.eclipse.osgi</artifactId>
	  <version>${eclipse.version}</version>
	</maven>
	<jpp>
	  <groupId>ECLIPSE</groupId>
	  <artifactId>org.eclipse.osgi</artifactId>
	  <version>${eclipse.version}</version>
	</jpp>
  </dependency>
  <dependency>
	<maven>
	  <groupId>org.eclipse.core</groupId>
	  <artifactId>org.eclipse.core.jobs</artifactId>
	  <version>${eclipse.version}</version>
	</maven>
	<jpp>
	  <groupId>ECLIPSE</groupId>
	  <artifactId>org.eclipse.core.jobs</artifactId>
	  <version>${eclipse.version}</version>
	</jpp>
  </dependency>
  <dependency>
	<maven>
	  <groupId>org.eclipse.core</groupId>
	  <artifactId>org.eclipse.core.resources</artifactId>
	  <version>${eclipse.version}</version>
	</maven>
	<jpp>
	  <groupId>ECLIPSE</groupId>
	  <artifactId>org.eclipse.core.resources</artifactId>
	  <version>${eclipse.version}</version>
	</jpp>
  </dependency>
  <dependency>
	<maven>
	  <groupId>org.eclipse.core</groupId>
	  <artifactId>org.eclipse.core.runtime</artifactId>
	  <version>${eclipse.version}</version>
	</maven>
	<jpp>
	  <groupId>ECLIPSE</groupId>
	  <artifactId>org.eclipse.core.runtime</artifactId>
	  <version>${eclipse.version}</version>
	</jpp>
  </dependency>
  <dependency>
	<maven>
	  <groupId>org.eclipse.jface</groupId>
	  <artifactId>org.eclipse.jface</artifactId>
	  <version>${eclipse.version}</version>
	</maven>
	<jpp>
	  <groupId>ECLIPSE</groupId>
	  <artifactId>org.eclipse.jface</artifactId>
	  <version>${eclipse.version}</version>
	</jpp>
  </dependency>

  <dependency>
	<maven>
	  <groupId>com.sun.xml.bind</groupId>
	  <artifactId>jaxb-impl</artifactId>
	  <version>${jaxb-impl.version}</version>
	</maven>
	<jpp>
	  <groupId>JPP</groupId>
	  <artifactId>jaxme/jaxme2</artifactId>
	  <version>0.5.2</version>
	</jpp>
  </dependency>

  <dependency>
	<maven>
	  <groupId>javax.xml.bind</groupId>
	  <artifactId>jaxb-api</artifactId>
	  <version>${jaxb-api.version}</version>
	</maven>
	<jpp>
	  <groupId>JPP</groupId>
	  <artifactId>jaxme/jaxmeapi</artifactId>
	  <version>0.5.2</version>
	</jpp>
  </dependency>

  <dependency>
	<maven>
	  <groupId>com.sun.xml.bind</groupId>
	  <artifactId>jaxb-xjc</artifactId>
	  <version>${jaxb-xjc.version}</version>
	</maven>
	<jpp>
	  <groupId>JPP</groupId>
	  <artifactId>jaxme/jaxmexs</artifactId>
	  <version>0.5.2</version>
	</jpp>
  </dependency>

  <dependency>
	<maven>
	  <groupId>org.apache.axis2</groupId>
	  <artifactId>axis2-saaj</artifactId>
	  <version>${axis2-saaj.version}</version>
	</maven>
	<jpp>
	  <groupId>JPP</groupId>
	  <artifactId>axis/saaj</artifactId>
	  <version>1.4</version>
	</jpp>
  </dependency>

  <dependency>
	<maven>
	  <groupId>org.apache.axis2</groupId>
	  <artifactId>axis2-saaj-api</artifactId>
	  <version>${axis2-saaj-api.version}</version>
	</maven>
	<jpp>
	  <groupId>JPP</groupId>
	  <artifactId>axis/saaj</artifactId>
	  <version>1.4</version>
	</jpp>
  </dependency>

</dependencies>
