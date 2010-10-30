#!/usr/bin/perl -w

require 'set_bin_755.pl';

#2.7.6-brew/component-info.xm

push @SPECHOOKS, 
 sub {
    my ($jpp, $alt) = @_;

    $jpp->disable_package('jedit');


    # native subpackage; let it be built from separate (older? rpm)
    if (0) {
# or ?
#    $jpp->get_section('package','')->subst(qr'\%define native  \%{\?_with_native:1}\%{!\?_without_native:0}', 	'%define native 1');

#    $jpp->disable_package('native');

# ---------------------- or ----------------
# bug to report
# if w/native w/o gcc should be arch!
    #$jpp->get_section('package','')->subst(qr'\%configure', 	'%configure --build=');

	$jpp->get_section('package','')->subst(qr'BuildArch:\s*noarch', '##BuildArch: noarch');
	$jpp->get_section('package','')->unshift_body("BuildRequires: gcc-c++\n");

	$jpp->get_section('package','javadoc')->push_body("BuildArch: noarch\n");
	$jpp->add_patch('antlr-2.7.7-alt-gcc44.patch', STRIP=>1);
	
	$jpp->get_section('description','native')->push_body(q{
%package        native-devel
Group:          Development/C++
Summary:        ANother Tool for Language Recognition (native version)

%description    native-devel
ANTLR, ANother Tool for Language Recognition, (formerly PCCTS) is a
language tool that provides a framework for constructing recognizers,
compilers, and translators from grammatical descriptions containing
C++ or Java actions [You can use PCCTS 1.xx to generate C-based
parsers].  This package includes the headers and static library for
native version of the antlr tool.

});
    # non-documented
	$jpp->_reset_speclist();
	$jpp->get_section('package','native-devel')->unshift_body('
# antlr.a vs antlr.so;
Conflicts: kde4sdk-libs
');
	$jpp->get_section('package','')->unshift_body('
%define _with_native 1
');

	$jpp->get_section('install')->push_body('
# C++ lib and headers, antlr-config
%define headers %{_includedir}/%{name}

mkdir -p $RPM_BUILD_ROOT{%{headers},%{_libdir}}
install -m 644 lib/cpp/antlr/*.hpp $RPM_BUILD_ROOT%{headers}
install -m 644 lib/cpp/src/libantlr.a $RPM_BUILD_ROOT%{_libdir}
install -m 755 scripts/antlr-config $RPM_BUILD_ROOT%{_bindir}
');
	$jpp->get_section('files','')->subst(qr!\%{headers}!,'#%{headers}');
	$jpp->get_section('files','')->subst(qr!\%{_libdir}!,'#%{_libdir}');
	$jpp->add_section('files','native-devel')->push_body(q{
%{headers}/*.hpp
%{_libdir}/libantlr.a
});
    }
}
__END__
35a36,46
> # If you want repolib package to be built,
> # issue the following: 'rpmbuild --with repolib'
> %define _with_repolib 1
>
> %define with_repolib %{?_with_repolib:1}%{!?_with_repolib:0}
> %define without_repolib %{!?_with_repolib:1}%{?_with_repolib:0}
>
> %define repodir %{_javadir}/repository.jboss.com/antlr/2.7.6-brew
> %define repodirlib %{repodir}/lib
> %define repodirsrc %{repodir}/src
>
53a65
> Source4:       antlr-component-info.xml
85a98,109
> %if %{with_repolib}
> %package repolib
> Summary:        Artifacts to be uploaded to a repository library
> Group:          Development/Java
> BuildArch: noarch
>
> %description repolib
> Artifacts to be uploaded to a repository library.
> This package is not meant to be installed but so its contents
> can be extracted through rpm2cpio.
> %endif
>
230a255,268
> %if %{with_repolib}
>        install -d -m 755 $RPM_BUILD_ROOT%{repodir}
>        install -d -m 755 $RPM_BUILD_ROOT%{repodirlib}
>        install -p -m 644 %{SOURCE4} $RPM_BUILD_ROOT%{repodir}/component-info.xml
> tag=`echo %{name}-%{version}-%{release} | sed 's|\.|_|g'`
> sed -i "s/@TAG@/$tag/g" $RPM_BUILD_ROOT%{repodir}/component-info.xml
>
>        install -d -m 755 $RPM_BUILD_ROOT%{repodirsrc}
>        install -p -m 644 %{PATCH0} $RPM_BUILD_ROOT%{repodirsrc}
>        install -p -m 644 %{SOURCE0} $RPM_BUILD_ROOT%{repodirsrc}
>        install -p -m 644 %{SOURCE1} $RPM_BUILD_ROOT%{repodirsrc}
>        cp -p $RPM_BUILD_ROOT%{_javadir}/antlr.jar $RPM_BUILD_ROOT%{repodirlib}
> %endif
>
282a321,324
> %if %{with_repolib}
> %files repolib
> %{repodir}
> %endif
