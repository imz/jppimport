#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($spec,) = @_;
    ## gcj support
    my $src2=$spec->add_source('ecj-gcj.tar.bz2',NUMBER=>2,HEADER=>
'# Use ECJ for GCJ
# cvs -d:pserver:anonymous@sourceware.org:/cvs/rhug \
# export -D 2013-12-11 eclipse-gcj
# tar cjf ecj-gcj.tar.bz2 eclipse-gcj
');
    $spec->add_patch('ecj-defaultto1.5.patch',STRIP=>1);
    $spec->add_patch('eclipse-gcj-nodummysymbol.patch',STRIP=>1,NUMBER=>55,DISABLE=>1);
    $spec->get_section('prep')->push_body(q!
# Use ECJ for GCJ's bytecode compiler
tar jxf %{SOURCE!.$src2.q!}
mv eclipse-gcj/org/eclipse/jdt/internal/compiler/batch/GCCMain.java \
  org/eclipse/jdt/internal/compiler/batch/
%patch55 -p1
cat eclipse-gcj/gcc.properties >> \
  org/eclipse/jdt/internal/compiler/batch/messages.properties
rm -rf eclipse-gcj
!);
    $spec->add_patch('ecj-gcj-for-4.6-api.patch',STRIP=>1);
    ## end gcj support

if (0) {
    ## native subpackage
    $spec->get_section('package','')->exclude_body('BuildArch:');
    $spec->get_section('package','')->unshift_body('# gcj support
BuildRequires: gcc-java >= 4.0.0
BuildRequires: /usr/bin/aot-compile-rpm
	    '."\n");
    $spec->get_section('description','')->push_body('
%package native
Summary:       Native(gcj) bits for %{name}
Group:         Development/Java
Requires:      %{name} = %{epoch}:%{version}-%{release}
Requires: libgcj >= 4.0.0
Requires(post): java-gcj-compat
Requires(postun): java-gcj-compat

%description native
AOT compiled ecj to speed up when running under GCJ.
');
    $spec->get_section('install')->push_body('
aot-compile-rpm
');
    $spec->get_section('files','')->push_body('
%files native
%{_libdir}/gcj/%{name}
');
    ## end native subpackage
}
    
    $spec->get_section('package','')->unshift_body('Obsoletes: ecj-standalone <= 3.4.2-alt4_0jpp6'."\n");

    # ecj should not have osgi dependencies.
    $spec->get_section('package','')->push_body('
AutoReq: yes, noosgi
AutoProv: yes, noosgi
');


    # hack -- exclude pom as it breaks builds due 
    # to strange deps on eclipse (moreover, eclipse does not have poms)
#    $spec->get_section('files','')->exclude_body('maven');
};
