#!/usr/bin/perl -w

require 'set_kill_rpath.pl';

push @SPECHOOKS, 
sub {
    my ($spec,) = @_;
    $spec->get_section('package','')->unshift_body('BuildRequires: mono-web javapackages-local'."\n");
    #disabled python-module-thrift; built from separate srpm
#    $spec->get_section('files','-n python-module-thrift')->delete();
};

    
    warn "WARNING!!! TODO!!! see below end for details";

1;

__END__

%prep
1)remove similar sed from fedora above
2)sed -i 's|libfb303_so_LDFLAGS = $(SHARED_LDFLAGS)|libfb303_so_LDFLAGS = $(SHARED_LDFLAGS) -L../../../lib/cpp/.libs -Wl,--no-as-needed -lthrift -Wl,--as-needed|g' contrib/fb303/cpp/Makefile.am
%build
configure ...
--without-haskell --without-csharp
%files
python-fb303 --
no-not-package-egg-info

__END__
--- thrift.spec	2017-11-23 19:40:48.919476722 +0200
+++ thrift.spec	2017-11-23 19:40:35.632767745 +0200
@@ -159,6 +159,7 @@
 Requires: %{name} = %{version}-%{release}
 Requires: python
 Obsoletes: python-%{name} < 0.10.0-1%{?dist}
+BuildArch: noarch
 
 %description -n python-module-thrift
 The python2-%{name} package contains Python bindings for %{name}.
@@ -298,7 +299,7 @@
 Summary: Python 2 bindings for fb303
 Requires: fb303 = %{version}-%{release}
 BuildRequires: python-devel
-Obsoletes: python-fb303 < 0.10.0-1%{?dist}
+BuildArch: noarch
 
 %description -n python-module-fb303
 The python2-fb303 package contains Python bindings for fb303.
@@ -334,12 +335,16 @@
 echo 'libthrift_c_glib_la_LIBADD = $(GLIB_LIBS) $(GOBJECT_LIBS) -L../cpp/.libs ' >> lib/c_glib/Makefile.am
 echo 'libthriftqt_la_LIBADD = $(QT_LIBS) -lthrift -L.libs' >> lib/cpp/Makefile.am
 echo 'libthriftz_la_LIBADD = $(ZLIB_LIBS) -lthrift -L.libs' >> lib/cpp/Makefile.am
+echo 'libthriftqt5_la_LIBADD = $(QT5_LIBS) -lthrift -L.libs' >> lib/cpp/Makefile.am
+echo 'libthriftnb_la_LIBADD = $(LIBEVENT_LIBS) -lthrift -L.libs' >> lib/cpp/Makefile.am
 echo 'EXTRA_libthriftqt_la_DEPENDENCIES = libthrift.la' >> lib/cpp/Makefile.am
 echo 'EXTRA_libthriftz_la_DEPENDENCIES = libthrift.la' >> lib/cpp/Makefile.am
+echo 'EXTRA_libthriftqt5_la_DEPENDENCIES = libthrift.la' >> lib/cpp/Makefile.am
+echo 'EXTRA_libthriftnb_la_DEPENDENCIES = libthrift.la' >> lib/cpp/Makefile.am
 
-# echo 'libfb303_so_LIBADD = -lthrift -L../../../lib/cpp/.libs' >> contrib/fb303/cpp/Makefile.am
+# echo 'libfb303_so_LIBADD = -L../../../lib/cpp/.libs -lthrift' >> contrib/fb303/cpp/Makefile.am
 
-sed -i 's|libfb303_so_LDFLAGS = $(SHARED_LDFLAGS)|libfb303_so_LDFLAGS = $(SHARED_LDFLAGS) -lthrift -L../../../lib/cpp/.libs -Wl,--as-needed|g' contrib/fb303/cpp/Makefile.am
+sed -i 's|libfb303_so_LDFLAGS = $(SHARED_LDFLAGS)|libfb303_so_LDFLAGS = $(SHARED_LDFLAGS) -Wl,--no-as-needed -lthrift -L../../../lib/cpp/.libs -Wl,--as-needed|g' contrib/fb303/cpp/Makefile.am
 
 # fix broken upstream check for ant version; we enforce this with BuildRequires, so no need to check here
 sed -i 's|ANT_VALID=.*|ANT_VALID=1|' aclocal/ax_javac_and_java.m4
@@ -389,7 +394,9 @@
 sh ./bootstrap.sh
 
 # use unversioned doc dirs where appropriate (via _pkgdocdir macro)
-%configure --disable-dependency-tracking --disable-static --with-boost=/usr %{ruby_configure} %{erlang_configure} %{golang_configure} %{php_configure} --docdir=%{?_pkgdocdir}%{!?_pkgdocdir:%{_docdir}/%{name}-%{version}}
+%configure --disable-dependency-tracking --disable-static --with-boost=/usr %{ruby_configure} %{erlang_configure} %{golang_configure} %{php_configure} --docdir=%{?_pkgdocdir}%{!?_pkgdocdir:%{_docdir}/%{name}-%{version}} \
+	   --without-haskell \
+	   --without-nodejs
 
 # eliminate unused direct shlib dependencies
 sed -i -e 's/ -shared / -Wl,--as-needed\0/g' libtool
