#!/usr/bin/perl -w

require 'set_fix_homedir_macro.pl';
require 'windows-thumbnail-database-in-package.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;

    # 5.5.27-5.5.31 do not compile with commons-el 1.0.1
    # properly subst s,commons-el,commons-el10
    $jpp->get_section('package','')->subst(qr'^BuildRequires: jakarta-commons-el','BuildRequires: jakarta-commons-el10');
    $jpp->get_section('package','common-lib')->subst_if(qr'commons-el','commons-el10',qr'^Requires');
    $jpp->get_section('build')->subst(qr'build-classpath commons-el','build-classpath commons-el10');
    $jpp->get_section('post','')->subst(qr'commons-el ','commons-el10 ');

    # ant 1.7 support
    $jpp->get_section('package','')->unshift_body('BuildRequires: ant-trax'."\n");
    $jpp->get_section('install')->subst(qr'ant/ant-nodeps','ant/ant-nodeps ant/ant-trax');

    $jpp->get_section('prep')->subst(qr'^jar xf /usr/share/java/apache-commons-launcher.jar','jar xf /usr/share/java/commons-launcher.jar');

    # hack against
    #ошибка: line 185: Dependency tokens must not contain '%<=>' symbols: Requires: tomcat5-common-lib = 0:5.5.31-2%{dist}
    $jpp->get_section('package','')->unshift_body('%define dist %nil'."\n");

    # hack against %post build-classpath
    $jpp->get_section('package','')->unshift_body('BuildRequires(pre): rpm-macros-alternatives'."\n");
    $jpp->get_section('post','')->unshift_body('%force_update_alternatives'."\n");

    $jpp->get_section('prep')->push_body(q!
for i in container/webapps/admin/*.jsp container/webapps/admin/*/*.jsp; do
    subst 's,locale="true",lang="true",' $i
done
!);

    # __fedora 11-15 struts 1.3.9 adaptation__(no need for jpackage)
    $jpp->get_section('package','')->subst(qr'^#BuildRequires: struts-taglib','BuildRequires: struts-taglib');
    $jpp->get_section('package','admin-webapps')->subst(qr'^#Requires: struts-taglib','Requires: struts-taglib');
    $jpp->get_section('package','admin-webapps')->subst(qr'^#Requires\(post\): struts-taglib','Requires(post): struts-taglib');
    $jpp->get_section('install')->subst(qr'ant/ant-trax xalan-j2-serializer"','ant/ant-trax xalan-j2-serializer struts-taglib"',qr'^export OPT_JAR_LIST');
    $jpp->get_section('post','admin-webapps')->subst(qr'commons-beanutils commons-collections commons-digester struts','commons-beanutils commons-collections commons-digester struts struts-taglib');

    # hack against tomcat parent pom not installed by dependencies.
    my $addpomline=q!Requires: %name-parent = %{epoch}:%{version}-%{release}!."\n";
    $jpp->get_section('package','jasper')->push_body($addpomline);
    $jpp->get_section('package','jsp-2.0-api')->push_body($addpomline);
    $jpp->get_section('package','servlet-2.4-api')->push_body($addpomline);
    $jpp->get_section('package','common-lib')->push_body($addpomline);
    $jpp->get_section('package','server-lib')->push_body($addpomline);
    $jpp->get_section('package','admin-webapps')->push_body($addpomline);
    $jpp->get_section('package','')->push_body($addpomline);
    $jpp->add_section('package','parent')->push_body(q!Group: Development/Java
Summary: Apache Tomcat parent pom for maven2
Obsoletes: tomcat5-poms < %{epoch}:%{version}

%description parent
Apache Tomcat parent pom for maven2

!);
    $jpp->get_section('files','')->exclude('mavendepmapfragdir');
    $jpp->get_section('files','')->exclude(qr'/maven2/poms/JPP.tomcat5-parent.pom');
    $jpp->add_section('files','parent')->push_body(q!%{_mavendepmapfragdir}/*
%{_datadir}/maven2/poms/JPP.tomcat5-parent.pom
!);
    
    # TODO: write proper tomcat5-5.5.init!
    # as a hack, an old version is taken
    $jpp->copy_to_sources('tomcat5-5.5.init');

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
    if (0) {
    # to make them 1.4, not 1.5
    $jpp->get_section('build')->subst(qr'ant\s+-Dservletapi.build="build"','ant -Dant.build.javac.source=1.4 -Dant.build.javac.target=1.4 -Dservletapi.build="build"');

    # additional hacks due to ecj of java6; REPLACE WITH TARGET 1.5 everywhere after get rid of 1.4
    $jpp->get_section('build')->subst(qr'compiler="modern" javadoc','compiler="modern" -Dant.build.javac.source=1.4 -Dant.build.javac.target=1.4 javadoc', qr'ant ');
    $jpp->get_section('build')->subst(qr'java_home}" build','java_home}" -Dant.build.javac.source=1.5 -Dant.build.javac.target=1.5 build', qr'ant ');
    $jpp->get_section('install')->subst(qr'ant\s+-D','ant -Dant.build.javac.source=1.4 -D');
    # end fedora specific 
    }
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

__END__
#     # hack against tomcat parent pom not installed by dependencies.
#     # It may be made a subpackage, but let it be just file dup.
# #    my $addpomline=q!#hack for pom closure
# #%_datadir/maven2/poms/JPP.tomcat5-parent.pom!."\n";
# #    $jpp->get_section('files','jasper')->push_body($addpomline);
# #    $jpp->get_section('files','servlet-2.4-api')->push_body($addpomline);
# #    $jpp->get_section('files','common-lib')->push_body($addpomline);

#     # moreover, old packages as jetty6-core mojo-maven2-plugins nanocontainer
#     # just breaks with new poms installed due to their depmap (TODO: edit it 
#     $jpp->add_section('package','poms')->push_body(q!Group: Development/Java
# Summary: Apache Tomcat poms for maven2

# %description poms
# Apache Tomcat poms for maven2

# !);
#     $jpp->add_section('files','poms')->push_body(q!%_datadir/maven2/poms/*
# !);
