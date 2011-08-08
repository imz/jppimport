#!/usr/bin/perl -w

require 'set_exclude_repolib.pl';

push @SPECHOOKS, 
 sub {
    my ($jpp, $alt) = @_;
    $jpp->add_patch('hsqldb-1.8.0.7-alt-init.patch',STRIP=>1);

#<13>May 10 21:40:01 rpmi: hsqldb-1:1.8.0.8-alt1_2.patch01.2jpp5 installed
#ln: target `hsqldb.jar' is not a directory
#ln: target `servlet.jar' is not a directory
#error: execution of %post scriptlet from hsqldb-1.8.0.8-alt1_2.patch01.2jpp5 ailed, exit status 1
#%post----------------
#cd %{_var}/lib/%{name}/lib
#   ln -s $(build-classpath hsqldb) hsqldb.jar
#   ln -s $(build-classpath servletapi5) servlet.jar
#
    $jpp->get_section('post')->subst(qr'\$\(build-classpath hsqldb\)','/usr/share/java/hsqldb.jar');
    $jpp->get_section('post')->subst(qr'\$\(build-classpath servletapi5\)','/usr/share/java/servletapi5.jar');

};
