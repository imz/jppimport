#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
};

__END__

195a196,198
> # hack; disabled jdk6 support - did not work :(
> sed -i 's,<condition property="isJDK6">,<condition property="isJDK5">,' build.xml
> 
264c267
< - converted from JPackage by jppimport script
---
> - hack: built w/o jdk6 support for jboss/jbossas 4 support
# more radical
0a1
> BuildRequires: java-1.5.0-devel
199a201
> export JAVA_HOME=/usr/lib/jvm/java-1.5.0
