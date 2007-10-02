#!/usr/bin/perl -w

require 'set_fix_jakarta_commons_cli.pl';
require 'set_bootstrap.pl';
#require 'set_target_14.pl';

$spechook = sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->subst(qr'gnu\.regexp','gnu-regexp');
    $jpp->get_section('package','')->subst(qr'BuildRequires: modello-maven-plugin','##BuildRequires: modello-maven-plugin');
    $jpp->get_section('package','')->push_body('BuildRequires: checkstyle-optional'."\n");
    $jpp->get_section('package','')->push_body('BuildRequires: saxon-scripts'."\n");
    $jpp->get_section('package','')->push_body('BuildRequires: maven2-bootstrap-bundle'."\n");
    $jpp->get_section('build')->subst(qr'/%3','/[%%]3');
    $jpp->get_section('build')->subst(qr'%3e','/[%%]3e');

    $jpp->add_patch('maven2-2.0.4-MANTTASKS-44.diff');

    $jpp->get_section('prep')->push_body('
cat <<EOF > m2_repo/repository/JPP/maven2/default_poms/JPP.maven2.plugins-site-plugin.pom
<project>
  <parent>
    <artifactId>maven-plugins</artifactId>
    <groupId>org.apache.maven.plugins</groupId>
    <version>1</version>
  </parent>
  <modelVersion>4.0.0</modelVersion>
  <artifactId>maven-site-plugin</artifactId>
  <packaging>maven-plugin</packaging>
  <name>Maven Site plugin</name>
  <version>2.0-SNAPSHOT</version>
  <prerequisites>
    <maven>2.0.2</maven>
  </prerequisites>
  <contributors>
    <contributor>
      <name>Naoki Nose</name>
      <email>ikkoan@mail.goo.ne.jp</email>
      <roles>
        <role>Japanese translator</role>
      </roles>
    </contributor>
    <contributor>
      <name>Michael Wechner</name>
      <email>michael.wechner@wyona.com</email>
      <roles>
        <role>German translator</role>
      </roles>
    </contributor>
    <contributor>
      <name>Piotr Bzdyl</name>
      <email>piotr@bzdyl.net</email>
      <roles>
        <role>Polish translator</role>
      </roles>
    </contributor>
    <contributor>
      <name>Domingos Creado</name>
      <email>dcreado@users.sf.net</email>
      <roles>
        <role>Brazilian Portuguese translator</role>
      </roles>
    </contributor>
    <contributor>
      <name>John Allen</name>
      <email>john_h_allen@hotmail.com</email>
    </contributor>
  </contributors>
  <dependencies>
    <dependency>
      <groupId>org.apache.maven</groupId>
      <artifactId>maven-plugin-api</artifactId>
      <version>2.0</version>
    </dependency>
    <dependency>
      <groupId>org.apache.maven</groupId>
      <artifactId>maven-artifact</artifactId>
      <version>2.0.2</version>
    </dependency>
    <dependency>
      <groupId>org.apache.maven</groupId>
      <artifactId>maven-project</artifactId>
      <version>2.0</version>
    </dependency>
    <dependency>
      <groupId>org.apache.maven</groupId>
      <artifactId>maven-settings</artifactId>
      <version>2.0</version>
    </dependency>
    <dependency>
      <groupId>org.apache.maven.doxia</groupId>
      <artifactId>doxia-site-renderer</artifactId>
      <version>1.0-alpha-8-SNAPSHOT</version>
    </dependency>
    <dependency>
      <groupId>org.apache.maven.reporting</groupId>
      <artifactId>maven-reporting-api</artifactId>
      <version>2.0.2</version>
    </dependency>
<!-- added by viy -->
    <dependency>
      <groupId>org.codehaus.plexus</groupId>
      <artifactId>plexus-i18n</artifactId>
      <version>1.0-beta-6</version>
    </dependency>
<!-- end added by viy -->
    <dependency>
      <groupId>org.codehaus.plexus</groupId>
      <artifactId>plexus-utils</artifactId>
      <version>1.1</version>
    </dependency>
    <dependency>
      <groupId>org.mortbay.jetty</groupId>
      <artifactId>jetty</artifactId>
      <version>6.0.0beta6</version>
    </dependency>
  </dependencies>
</project>
EOF

mkdir -p m2_repo/repository/org.codehaus.plexus/
ln -s /usr/share/java/plexus/i18n.jar m2_repo/repository/org.codehaus.plexus/plexus-i18n.jar

');


    $jpp->get_section('prep')->push_body('
cat <<EOF > maven2-plugins/maven-site-plugin/pom.xml
<project>
  <parent>
    <artifactId>maven-plugin-parent</artifactId>
    <groupId>org.apache.maven.plugins</groupId>
    <version>2.0.1</version>
  </parent>
  <modelVersion>4.0.0</modelVersion>
  <artifactId>maven-site-plugin</artifactId>
  <packaging>maven-plugin</packaging>
  <name>Maven Site plugin</name>
  <version>2.0-SNAPSHOT</version>
  <prerequisites>
    <maven>2.0.2</maven>
  </prerequisites>
  <developers>
    <developer>
      <id>vsiveton</id>
      <name>Vincent Siveton</name>
      <email>vsiveton@apache.org</email>
      <organization>Apache Software Foundation</organization>
      <roles>
        <role>Java Developer</role>
      </roles>
      <timezone>-5</timezone>
    </developer>
  </developers>
  <contributors>
    <contributor>
      <name>Naoki Nose</name>
      <email>ikkoan@mail.goo.ne.jp</email>
      <roles>
        <role>Japanese translator</role>
      </roles>
    </contributor>
    <contributor>
      <name>Michael Wechner</name>
      <email>michael.wechner@wyona.com</email>
      <roles>
        <role>German translator</role>
      </roles>
    </contributor>
    <contributor>
      <name>Piotr Bzdyl</name>
      <email>piotr@bzdyl.net</email>
      <roles>
        <role>Polish translator</role>
      </roles>
    </contributor>
    <contributor>
      <name>Domingos Creado</name>
      <email>dcreado@users.sf.net</email>
      <roles>
        <role>Brazilian Portuguese translator</role>
      </roles>
    </contributor>
    <contributor>
      <name>John Allen</name>
      <email>john_h_allen@hotmail.com</email>
    </contributor>
  </contributors>
  <dependencies>
    <dependency>
      <groupId>org.apache.maven</groupId>
      <artifactId>maven-artifact</artifactId>
      <version>2.0.2</version>
    </dependency>
    <dependency>
      <groupId>org.apache.maven</groupId>
      <artifactId>maven-project</artifactId>
    </dependency>
    <dependency>
      <groupId>org.apache.maven.doxia</groupId>
      <artifactId>doxia-site-renderer</artifactId>
      <version>1.0-alpha-7-SNAPSHOT</version>
      <exclusions>
        <exclusion>
          <!-- TODO: upgrade p-velo -->
          <groupId>plexus</groupId>
          <artifactId>plexus-utils</artifactId>
        </exclusion>
      </exclusions>
    </dependency>
    <dependency>
      <groupId>org.apache.maven.reporting</groupId>
      <artifactId>maven-reporting-api</artifactId>
      <version>2.0.2</version>
    </dependency>
    <dependency>
      <groupId>org.codehaus.plexus</groupId>
      <artifactId>plexus-utils</artifactId>
    </dependency>
<!-- added by viy -->
    <dependency>
      <groupId>org.codehaus.plexus</groupId>
      <artifactId>plexus-i18n</artifactId>
      <version>1.0-beta-6</version>
    </dependency>
  </dependencies>
</project>
EOF
');

# does not work :(
    $jpp->get_section('prep')->push_body('
mkdir -p maven2-plugins/maven-site-plugin/src/main/resources/META-INF/plexus/
cat <<EOF > maven2-plugins/maven-site-plugin/src/main/resources/META-INF/plexus/components.xml
<component-set>
  <components>
    <component>
      <role>org.codehaus.plexus.i18n.I18N</role>
      <implementation>org.codehaus.plexus.i18n.DefaultI18N</implementation>
    </component>
  </components>
</component-set>
EOF
');

};

__END__

maven-site-plugin:
    <dependency>
      <groupId>plexus</groupId>
      <artifactId>plexus-i18n</artifactId>
      <version>1.0-beta-2-SNAPSHOT</version>
      <type>jar</type>
      <scope>compile</scope>
    </dependency>

BuildRequires: jaxen >= 1.1
BuildRequires: jdom >= 1.0
BuildRequires: jmock >= 1.0.1
BuildRequires: jline >= 0.8.1
BuildRequires: jsch >= 0.1.20
BuildRequires: jtidy >= 1.0
BuildRequires: junit >= 3.8.2
BuildRequires: maven2-common-poms >= 1.0-3
BuildRequires: maven-doxia >= 1.0-0.a7.3
BuildRequires: maven-jxr >= 1.0-2
BuildRequires: maven-surefire >= 1.5.3-2
BuildRequires: maven-surefire-booter >= 1.5.3-2
BuildRequires: maven-wagon >= 1.0
BuildRequires: nekohtml >= 0.9.3
BuildRequires: oro >= 2.0.8
BuildRequires: plexus-ant-factory >= 1.0-0.a1.2
BuildRequires: plexus-bsh-factory >= 1.0-0.a7s.2
BuildRequires: plexus-archiver >= 1.0-0.a6
BuildRequires: plexus-compiler >= 1.5.1
BuildRequires: plexus-container-default >= 1.0
BuildRequires: plexus-i18n >= 1.0
BuildRequires: plexus-interactivity >= 1.0
BuildRequires: plexus-utils >= 1.2
BuildRequires: plexus-velocity >= 1.1.2
BuildRequires: pmd >= 3.6
BuildRequires: qdox >= 1.5
BuildRequires: rhino >= 1.5
BuildRequires: velocity >= 1.4
BuildRequires: xerces-j2 >= 2.7.1
BuildRequires: xalan-j2 >= 2.6.0
