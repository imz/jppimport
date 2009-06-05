#!/usr/bin/perl -w

require 'set_fix_homedir_macro.pl';
require 'windows-thumbnail-database-in-package.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;

    # hack against %post build-classpath
    $jpp->get_section('package','')->unshift_body('BuildRequires(pre): rpm-macros-alternatives'."\n");
    $jpp->get_section('post','')->unshift_body('%force_update_alternatives'."\n");

    # due to ecj :(
    $jpp->get_section('package')->subst(qr'jpackage-compat','jpackage-1.6-compat');

    # struts 1.3.9
    #$jpp->get_section('package','')->unshift_body('BuildRequires: struts-taglib'."\n");
    
    # hack against tomcat parent pom not installed by dependencies.
    # It may be made a subpackage, but let it be just file dup.
#    my $addpomline=q!#hack for pom closure
#%_datadir/maven2/poms/JPP.tomcat5-parent.pom!."\n";
    my $addpomline=q!#hack for poms cause conflicts :(
%exclude %_datadir/maven2/poms/*!."\n";
    $jpp->get_section('files','jasper')->push_body($addpomline);
    $jpp->get_section('files','jsp-2.0-api')->push_body($addpomline);
    $jpp->get_section('files','servlet-2.4-api')->push_body($addpomline);
    $jpp->get_section('files','common-lib')->push_body($addpomline);

    # moreover, old packages as jetty6-core mojo-maven2-plugins nanocontainer plexus-service-jetty
    # just breaks with new poms installed due to their depmap (TODO: edit it and use tomcat5-poms)
    $jpp->add_section('package','poms')->push_body(q!Group: Development/Java
Summary: Apache Tomcat poms for maven2

%description poms
Apache Tomcat poms for maven2

!);
    $jpp->add_section('files','poms')->push_body(q!%_datadir/maven2/poms/*
!);


    # TODO: write proper tomcat5-5.5.init!
    # as a hack, an old version is taken
    $jpp->copy_to_sources('tomcat5-5.5.init');
    $jpp->get_section('package','')->subst_if('Requires','#Requires',qr'/lib/lsb/init-functions');

#warning: file /usr/bin/jasper5-setclasspath.sh is packaged into both tomcat5 and tomcat5-jasper
#warning: file /usr/bin/jasper5.sh is packaged into both tomcat5 and tomcat5-jasper
#warning: file /usr/bin/jspc5.sh is packaged into both tomcat5 and tomcat5-jasper
    $jpp->get_section('files','')->push_body(q'%exclude %_bindir/jasper5-setclasspath.sh
%exclude %_bindir/jasper5.sh
%exclude %_bindir/jspc5.sh
');


    # BUG to report (5.5.25 1-fc9) too
    $jpp->get_section('build')->subst(qr'%{java.home}','%{java_home}');

    # fedora specific (5.5.25 1-fc9)
    $jpp->get_section('package','')->push_body('BuildRequires: zip'."\n");

    # to make them 1.4, not 1.5
    $jpp->get_section('build')->subst(qr'ant\s+-Dservletapi.build="build"','ant -Dant.build.javac.source=1.4 -Dant.build.javac.target=1.4 -Dservletapi.build="build"');

    # additional hacks due to ecj of java6; REPLACE WITH TARGET 1.5 everywhere after get rid of 1.4
    $jpp->get_section('build')->subst(qr'compiler="modern" javadoc','compiler="modern" -Dant.build.javac.source=1.4 -Dant.build.javac.target=1.4 javadoc', qr'ant ');
    $jpp->get_section('build')->subst(qr'java_home}" build','java_home}" -Dant.build.javac.source=1.5 -Dant.build.javac.target=1.5 build', qr'ant ');
    $jpp->get_section('install')->subst(qr'ant\s+-D','ant -Dant.build.javac.source=1.4 -D');
    # end fedora specific 

    $jpp->get_section('package','server-lib')->push_body('Requires: jaf javamail'."\n");

    $jpp->get_section('package','')->push_body('Provides: %{name}-server = %{version}-%{release}'."\n");
    $jpp->get_section('package','')->push_body('Obsoletes: %{name}-server <= 5.5.16-alt1.1'."\n");
    $jpp->get_section('package','admin-webapps')->push_body('Provides: %{name}-admin-webapps = %{version}-%{release}'."\n");
    $jpp->raw_rename_section('admin-webapps','webapps-admin');
    # #14415
    $jpp->get_section('description','')->subst(qr'We invite you to participate in this open development project. To','');
    $jpp->get_section('description','')->subst(qr'learn more about getting involved, click here.','');


    $jpp->get_section('pre')->subst(qr'-[gu] %\{tcuid\}','');

    # a part of #%post_service %name that is not implemented there:
    # condrestart on upgrade 
    $jpp->get_section('post')->push_body('/sbin/service %name condrestart'."\n");

    # merge from old alt tomcat5:
    # do we really need all of this?
    $jpp->get_section('post','webapps')->push_body(q'/sbin/service %name condrestart
');

    $jpp->get_section('post','webapps-admin')->push_body(q'/sbin/service %name condrestart
');

    $jpp->get_section('preun','webapps')->push_body(q'[ $1 != 0 ] || /sbin/service %name condrestart
');

    $jpp->get_section('preun','webapps-admin')->push_body(q'[ $1 != 0 ] || /sbin/service %name condrestart
');

    # todo: make an extension?
    $jpp->get_section('install')->push_body('mkdir -p $RPM_BUILD_ROOT/%_altdir/
cat >>$RPM_BUILD_ROOT/%_altdir/servletapi_%{name}<<EOF
%{_javadir}/servletapi.jar	%{_javadir}/%{name}-servlet-2.4-api-%{version}.jar	20400
EOF
');
    $jpp->get_section('files','servlet-2.4-api')->push_body('%_altdir/servletapi_*'."\n");
    $jpp->get_section('install')->push_body(
q'
%triggerpostun -- tomcat5-server <= 5.5.16-alt1.1
for i in common/classes common/endorsed common/lib shared/classes shared/lib webapps; do
if [ -d /usr/lib/tomcat5/$i ]; then
    echo "upgrade: moving old /usr/lib/tomcat5/$i to /var/lib/tomcat5/$i"
    mv -f /usr/lib/tomcat5/$i/* /var/lib/tomcat5/$i/
fi
done || :
');

}
__DATA__
todo: verify logrotate


__fedora struts 1.3.9 adaptation__(no need for jpackage)
144c144
< #BuildRequires: struts-taglib >= 0:1.3.8
---
> BuildRequires: struts-taglib >= 0:1.3.8
237c237
< #Requires: struts-taglib >= 0:1.3.8
---
> Requires: struts-taglib >= 0:1.3.8
245c245
< #Requires(post): struts-taglib
---
> Requires(post): struts-taglib
423a424,430
> for i in container/webapps/admin/*.jsp container/webapps/admin/*/*.jsp; do
>       subst 's,locale="true",lang="true",' $i
> done
>
633c640
<     export OPT_JAR_LIST="ant/ant-trax xalan-j2-serializer"
---
>     export OPT_JAR_LIST="ant/ant-trax xalan-j2-serializer struts-taglib"
1033c1040
<     commons-beanutils commons-collections commons-digester struts \
---
>     commons-beanutils commons-collections commons-digester struts struts-taglib \
