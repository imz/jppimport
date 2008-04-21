#!/usr/bin/perl -w

require 'set_bin_755.pl';

$spechook = sub {
    my ($jpp, $alt) = @_;

    $jpp->disable_package('jedit');

#    $jpp->get_section('package','')->subst(qr'\%define native  \%{\?_with_native:1}\%{!\?_without_native:0}', 	'%define native 0');
#    $jpp->disable_package('native');
#    $jpp->set_changelog('- imported with jppimport script; note: w/o native');

# ---------------------- or ----------------
# bug to report
# if w/native w/o gcc should be arch!
    #$jpp->get_section('package','')->subst(qr'\%configure', 	'%configure --build=');

    $jpp->get_section('package','')->subst(qr'BuildArch:\s*noarch', '##BuildArch: noarch');
    $jpp->get_section('package','')->unshift_body("BuildRequires: gcc-c++\n");

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

    $jpp->get_section('files','')->subst(qr!\%{headers}!,'#%{headers}');
    $jpp->get_section('files','')->subst(qr!\%{_libdir}!,'#%{_libdir}');
    $jpp->add_section('files','native-devel')->push_body(q{
%{headers}/*.hpp
%{_libdir}/libantlr.a
});

}
