#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($spec,) = @_;
    $spec->get_section('install')->subst_body_if(qr'macros.jruby','macros-jruby',qr'_rpmmacrosdir');
    $spec->get_section('files','devel')->subst_body_if(qr'macros.jruby','macros-jruby',qr'_rpmmacrosdir');
    $spec->get_section('package','')->unshift_body('%filter_from_requires /.usr.lib.*jffi/d'."\n");

    $spec->get_section('package','devel')->push_body('Requires:       rpm-macros-%{name} = %{EVR}'."\n");
    $spec->get_section('description','devel')->push_body('
%package -n rpm-macros-%{name}
Summary: Set of RPM macros for packaging %name-based applications
Group: Development/Java
# uncomment if macroses are platform-neutral
#BuildArch: noarch
# helps old apt to resolve file conflict at dist-upgrade (thanks to Stanislav Ievlev)
Conflicts: jruby-devel <= 1.7.22-alt1_6jpp8

%description -n rpm-macros-%{name}
Set of RPM macros for packaging %name-based applications for ALT Linux.
Install this package if you want to create RPM packages that use %name.
'."\n");
    $spec->get_section('files','devel')->exclude_body('_rpmmacrosdir');
    $spec->get_section('files','devel')->push_body('%exclude %_rpmmacrosdir/*

%files -n rpm-macros-%{name}
%_rpmmacrosdir/*
'."\n");

};

__END__
--- jruby-1.7.22-alt2_8jpp8/jruby.spec	2019-07-13 12:19:33.000000000 +0000
+++ jruby-1.7.22-alt1_6jpp8.qa2/jruby.spec	2018-10-14 16:23:24.000000000 +0000
@@ -241,24 +255,26 @@ EOF
 # own the JRuby specific files under RubyGems dir
 %{rubygems_dir}/rubygems/defaults/jruby.rb
 # exclude bundled gems
-%exclude %{jruby_vendordir}/ruby/1.9/json*
-%exclude %{jruby_vendordir}/ruby/1.9/rdoc*
-%exclude %{jruby_vendordir}/ruby/1.9/rake*
-%exclude %{jruby_vendordir}/ruby/gems
+#%exclude %{jruby_vendordir}/ruby/1.9/json*
+#%exclude %{jruby_vendordir}/ruby/1.9/rdoc*
+#%exclude %{jruby_vendordir}/ruby/1.9/rake*
+#%exclude %{jruby_vendordir}/ruby/gems
 # exclude all of the rubygems stuff
-%exclude %{jruby_vendordir}/ruby/shared/*ubygems*
-%exclude %{jruby_vendordir}/ruby/shared/rbconfig
+#%exclude %{jruby_vendordir}/ruby/shared/*ubygems*
+#%exclude %{jruby_vendordir}/ruby/shared/rbconfig
 
 %files devel
 %exclude %_rpmmacrosdir/*
