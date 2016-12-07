#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($spec, $parent) = @_;
    $spec->get_section('install')->subst_body_if(qr'/\&\.gz/','/&.*/',qr'^sed');

    # TODO: with tests and bootstrap=1
    # dependency on python-devel -> drop
    # dependency on python3-module-setuptools - add

    $spec->main_section->unshift_body('%add_python3_path /usr/share/java-utils/'."\n");
    my $opid=$spec->add_source('osgi-fc.prov.files');
    my $mpid=$spec->add_source('maven.prov.files');
    my $meid=$spec->add_source('maven.env');
    $spec->add_patch('javapackages-tools-4.6.0-alt-use-enviroment.patch',STRIP=>1);
    $spec->add_patch('javapackages-tools-4.6.0-alt-req-headless-off.patch',STRIP=>1);
    $spec->add_patch('javapackages-tools-4.6.0-alt-shade-jar.patch',STRIP=>1);
    $spec->add_patch('macros.fjava-to-alt-rpm404.patch',STRIP=>1);
    $spec->add_patch('macros.jpackage-alt-script.patch',STRIP=>1);

    $spec->get_section('package','')->unshift_body('BuildRequires: source-highlight python3-module-nose python3-module-setuptools-tests'."\n");

    # if set _jnidir = %_libdir/java
    #$spec->main_section->exclude_body(qr'^BuildArch:\s+noarch');
    #$spec->get_section('build')->unshift_body_after(qr'configure','sed -i -e s,jnidir=/java,jnidir=%_libdir/java, config.status'."\n");
    #map {if ($_->get_type() eq 'package') {
    #	$_->push_body('BuildArch: noarch'."\n") if !
    #	$_->match_body(qr'^BuildArch:\s+noarch');
    #	 }
    #} $spec->get_sections();

    $spec->main_section->exclude_body(qr'^BuildRequires:\s+scl-utils-build');

    $spec->main_section->push_body('
Conflicts:       jpackage-utils < 0:5.0.1
Obsoletes:       jpackage-utils < 0:5.0.1
Provides:       jpackage-utils = 1:5.0.0'."\n");

    $spec->main_section->unshift_body('# optional dependencies of jpackage-utils
%filter_from_requires /^.usr.bin.jar/d
%filter_from_requires /^objectweb-asm/d
%define _unpackaged_files_terminate_build 1
'."\n");


    $spec->get_section('prep')->push_body(q!
# alt specific shabang
sed -i -e 1,1s,/bin/bash,/bin/sh, java-utils/java-wrapper bin/*
!."\n");

    $spec->get_section('install')->push_body(q@
install -m755 -D %{SOURCE@.$mpid.q@} %buildroot/usr/lib/rpm/maven.prov.files
install -m755 -D %{SOURCE@.$mpid.q@} %buildroot/usr/lib/rpm/maven.req.files

install -m755 -D %{SOURCE@.$mpid.q@} %buildroot/usr/lib/rpm/javadoc.req.files
sed -i -e s,/usr/share/maven-metadata/,/usr/share/javadoc/, %buildroot/usr/lib/rpm/javadoc.req.files

install -m755 -D %{SOURCE@.$opid.q@} %buildroot/usr/lib/rpm/osgi-fc.prov.files
install -m755 -D %{SOURCE@.$opid.q@} %buildroot/usr/lib/rpm/osgi-fc.req.files

chmod 755 %buildroot/usr/lib/rpm/*.req* %buildroot/usr/lib/rpm/*.prov*
sed -i -e 's,^#!python,#!/usr/bin/python,' %buildroot/usr/lib/rpm/*.req* %buildroot/usr/lib/rpm/*.prov*

install -m755 -D %{SOURCE@.$meid.q@} %buildroot%_rpmmacrosdir/maven.env
@."\n");

    $spec->get_section('install')->push_body(q!
# in rpm-build-java
sed -i -e '/usr\/lib\/rpm/d' files-common
# move /usr/share/xmvn/* to maven-local
grep /usr/share/xmvn files-common >> files-maven
sed -i -e '/usr\/share\/xmvn/d' files-common
sed -i -e '/usr\/share\/java-utils\/.*\.py/d' files-common
sed -i -e '/usr\/bin\/xmvn-builddep/d' files-common

rm -rf %buildroot/usr/lib/rpm/fileattrs

pushd %buildroot%_rpmmacrosdir/
mv macros.fjava javapackages-fjava
mv macros.jpackage javapackages-jpackage
popd

pushd %buildroot/usr/lib/rpm/
mv osgi.prov osgi-fc.prov
mv osgi.req osgi-fc.req
popd
!."\n");

    $spec->get_section('description','')->push_body(q!
%package -n rpm-macros-java
Summary: RPM helper macros to build Java packages
Group: Development/Java
Conflicts: rpm-build-java < 0:5.0.0-alt34
# comment if jnidir patch is used
BuildArch:      noarch

%description -n rpm-macros-java
These helper macros facilitate creation of RPM packages containing Java
bytecode archives and Javadoc documentation.

%package -n rpm-build-java
Summary: RPM build helpers for Java packages
Group: Development/Java
BuildArch:      noarch
Requires:       javapackages-tools = %{epoch}:%{version}-%{release}
Requires: 	rpm-macros-java >= %{epoch}:%{version}-%{release}
#Requires: rpm-build-java-osgi >= %{epoch}:%{version}-%{release}
# moved from main package; not for runtime
Requires:       python3-module-javapackages = %{epoch}:%{version}-%{release}
Requires:       python3

%description -n rpm-build-java
RPM build helpers for Java packages.

!."\n");
    # moved to rpm-build-java
    $spec->main_section->exclude_body(qr'Requires:\s+python3');

    $spec->get_section('files','doc')->push_body('
%files -n rpm-macros-java
%_rpmmacrosdir/javapackages-fjava
%_rpmmacrosdir/javapackages-jpackage

%files -n rpm-build-java
/usr/lib/rpm/maven.*
/usr/lib/rpm/javadoc.*
/usr/lib/rpm/osgi-fc.*
%_rpmmacrosdir/maven.env
%_datadir/java-utils/maven_depmap.py
%_datadir/java-utils/pom_editor.py
%_datadir/java-utils/request-artifact.py
%_bindir/xmvn-builddep
%_datadir/java-utils/__pycache__/maven_depmap.*
%_datadir/java-utils/__pycache__/pom_editor.*
%_datadir/java-utils/__pycache__/request-artifact.*
'."\n");

    $spec->get_section('files','-n javapackages-local')->push_body('
%_datadir/java-utils/__pycache__
%exclude %_datadir/java-utils/__pycache__/maven_depmap.*
%exclude %_datadir/java-utils/__pycache__/pom_editor.*
%exclude %_datadir/java-utils/__pycache__/request-artifact.*
'."\n");

};

__END__
