#!/usr/bin/perl -w

$spechook = sub {
    my ($jpp, $alt) = @_;
    # bugs to report
    # TODO: clirr manual is empty!!!
    # BUG; why it depends on maven!
    $jpp->get_section('package','')->subst(qr'^Requires:\s+maven','#Requires: maven');
    $jpp->get_section('package','maven-plugin')->push_body('
# moved form core package (strange deps for it)
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
BASE_JARS="bcel commons-cli commons-lang"

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
    # is it really needed?
    # bug to report: obsolete maven-javaapp-plugin version 1.3.1?
    $jpp->get_section('prep')->push_body(q!%__subst s,1.3.1,1.4, %{SOURCE4}
!);

    $jpp->get_section('prep','')->push_body('
%__subst s,maven-javaapp-plugin-1.3.1,maven-javaapp-plugin-1.4, core/project.xml'."\n");
