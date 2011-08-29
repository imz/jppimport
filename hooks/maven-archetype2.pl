#!/usr/bin/perl -w

require 'set_jetty6_servlet_25_api.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    my $id=$jpp->add_source('maven-archetype2-components.xml');
    $jpp->get_section('install')->push_body(q!
# forcefully add missing plexus components.xml
rm -rf META-INF
mkdir -p META-INF/plexus
cp %{SOURCE!.$id.q!} META-INF/plexus/components.xml
jar uf %buildroot%_datadir/maven2/plugins/archetype2-plugin-%version.jar META-INF/plexus
!);
}

__END__
# 6.0:
# due to build with velocity14 instead of velocity
/usr/src/RPM/BUILD/maven-archetype-2.0-alpha-3/archetype-common/src/main/java/org/apache/maven/archetype/generator/DefaultFilesetArchetypeGenerator.java:[716,36] cannot find symbol
symbol  : method resourceExists(java.lang.String)
location: class org.apache.velocity.app.VelocityEngine
# hack to help when velocity14 pom and fragments will be fixed
> sed -i -e 's,<groupId>velocity</groupId>,<groupId>org.apache.velocity</groupId>,' archetype-common/pom.xml
# also jpp depmap was hacked to point to velocity.jar
