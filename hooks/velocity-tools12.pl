#!/usr/bin/perl -w

#require 'set_rename_package.pl';

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
#    &rename_package ($jpp, $alt, 'velocity-tools', 'velocity-tools12');
#    $jpp->get_section('package','')->unshift_body('Provides: velocity-tools = 1.2'."\n");
#    $jpp->get_section('package','')->subst_if(qr'velocity','velocity14', qr'Requires:');
};

__END__
# struts 1.3 support
3a4
> BuildRequires: struts-taglib struts-tiles
147c148,149
< ant jar.struts jar.view jar.generic javadoc docs
---
> export CLASSPATH=$(build-classpath  struts-taglib struts-tiles)
> ant -Dbuild.sysclasspath=first jar.struts jar.view jar.generic javadoc docs

__DEAD__
# was to do it manually, but ... :) 
    $jpp->get_section('install')->push_body(q!
rm %buildroot%_javadir/velocity-tools.jar
rm %buildroot%_javadir/velocity-tools-generic.jar
rm %buildroot%_javadir/velocity-tools-view.jar
!);
