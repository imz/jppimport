#!/usr/bin/perl -w

# until we fully translate to java6
require 'set_maven1_target_14.pl';
require 'set_apache_translation.pl';

# 6.0 hook
push @SPECHOOKS, 
 sub {
    my ($jpp, $alt) = @_;

    # BUG: duplicate files with maven-plugin
    $jpp->get_section('files','')->push_body('%exclude %_javadir/maven-plugins*'."\n");

    # TODO: script
    $jpp->get_section('files','')->push_body('%_bindir/%name'."\n");
    $jpp->get_section('install')->push_body(q{
mkdir -p $RPM_BUILD_ROOT%_bindir/
cat > $RPM_BUILD_ROOT%_bindir/%name <<'EOF'
#!/bin/sh
# 
# Clirr startup script
#
# JPackage Project <http://www.jpackage.org/>

# Source functions library
if [ -f /usr/share/java-utils/java-functions ] ; then 
  . /usr/share/java-utils/java-functions
else
  echo "Can't find functions library, aborting"
  exit 1
fi

# Configuration
MAIN_CLASS=net.sf.clirr.cli.Clirr
BASE_JARS="bcel commons-cli commons-lang clirr-core"

# Set parameters
set_jvm
set_classpath $BASE_JARS
set_flags $BASE_FLAGS
set_options $BASE_OPTIONS

# Let's start
run "$@"
EOF

chmod 755 $RPM_BUILD_ROOT%_bindir/%name
});
}

__END__
