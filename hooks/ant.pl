#!/usr/bin/perl -w

require 'set_manual_no_dereference.pl';

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    my %pkg_rename=qw/
ant-apache-bcel		ant-bcel
ant-apache-bsf		ant-bsf
ant-apache-log4j	ant-log4j
ant-apache-resolver	ant-xml-resolver
/;
#alteady contained
#ant-apache-oro		ant-jakarta-oro
#ant-apache-regexp	ant-jakarta-regexp
    $jpp->get_section('package','javamail')->subst_if(qr'>= 0:1.2-5jpp','',qr'Requires');

    foreach my $pkg (keys(%pkg_rename)) {
#	print "renaming: $pkg -> $pkg_rename{$pkg}\n";
	$jpp->get_section('package',"-n ".$pkg)->push_body('
#Provides: '.$pkg_rename{$pkg}.' = %{epoch}:%version-%release
Obsoletes: '.$pkg_rename{$pkg}.' < 1.8.0
');
    }
    $jpp->get_section('package','manual')->push_body('Obsoletes: ant-task-reference < 1.8.0'."\n");

    $jpp->get_section('package','')->push_body('
Obsoletes:      %{name}-style-xsl < %{version}
Obsoletes:      %{name}-nodeps < %{version}
Provides:       %{name}-nodeps = %{version}
Obsoletes:      %{name}-trax < %{version}
Provides:       %{name}-trax = %{version}
'."\n");

    $jpp->get_section('description','')->push_body('

%package optional
Summary: Optional tasks for Ant
Group: Development/Java

Requires: %name = %{?epoch:%epoch:}%version-%release
Requires: %name-antlr = %{?epoch:%epoch:}%version-%release
Requires: %name-apache-bcel = %{?epoch:%epoch:}%version-%release
Requires: %name-commons-logging = %{?epoch:%epoch:}%version-%release
Requires: %name-commons-net = %{?epoch:%epoch:}%version-%release
Requires: %name-apache-oro = %{?epoch:%epoch:}%version-%release
Requires: %name-apache-regexp = %{?epoch:%epoch:}%version-%release
Requires: %name-javamail = %{?epoch:%epoch:}%version-%release
Requires: %name-jdepend = %{?epoch:%epoch:}%version-%release
Requires: %name-jmf = %{?epoch:%epoch:}%version-%release
Requires: %name-jsch = %{?epoch:%epoch:}%version-%release
Requires: %name-junit = %{?epoch:%epoch:}%version-%release
Requires: %name-apache-log4j = %{?epoch:%epoch:}%version-%release
Requires: %name-swing = %{?epoch:%epoch:}%version-%release
Requires: %name-apache-resolver = %{?epoch:%epoch:}%version-%release
Requires: %name-apache-bsf = %{?epoch:%epoch:}%version-%release
#Requires: %name-jai = %{?epoch:%epoch:}%version-%release
#Requires: %name-stylebook = %{?epoch:%epoch:}%version-%release

%description optional
Optional build tasks for ant, a platform-independent build tool for Java.

%files optional

'."\n");

}



__END__
#extra alt packages
ant-jai
ant-stylebook
ant-optional
# subpackages
##ant-style-xsl
