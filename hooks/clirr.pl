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
# old 5.0 hook
require 'set_maven1_target_14.pl';

push @SPECHOOKS, 
 sub {
    my ($jpp, $alt) = @_;
    # bugs to report

    # TODO: get rid of 
    # hack; bcel is 5.2 in 1.7, while in 5.0 it downgraded to 5.1
    $jpp->add_patch('clirr-0.6-alt-bcel51.patch');


    # TODO: clirr manual is empty!!!
    # BUG; why it depends on maven!
    $jpp->get_section('package','')->subst(qr'^Requires:\s+maven','#Requires: maven');
    $jpp->get_section('package','maven-plugin')->push_body('
# moved from core package (strange deps for it)
Requires: maven >= 0:1.1                                                        
Requires: maven-model
');

    $jpp->get_section('build')->unshift_body_before(q!
# dirty hack that finally works
mkdir -p .maven/repository/JPP/plugins/
ln -s /usr/share/java/maven-plugins/maven-javaapp-plugin.jar .maven/repository/JPP/plugins/
!, qr'^maven -Dmaven');

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
