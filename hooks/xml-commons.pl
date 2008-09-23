#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    # alt sppecific - removed ghosted alternatives symlink
    $jpp->get_section('install')->subst(qr'ln -s %\{_sysconfdir\}/alternatives/%\{name\}-apis-javadoc \$RPM_BUILD_ROOT%\{_javadocdir\}/%\{name\}-apis # ghost symlink','#ln -s %{_sysconfdir}/alternatives/%{name}-apis-javadoc $RPM_BUILD_ROOT%{_javadocdir}/%{name}-apis # ghost symlink');
    $jpp->get_section('files','jaxp-1.3-apis-javadoc')->subst(qr'%ghost %\{_javadocdir\}/\%\{name\}-apis','#%ghost %{_javadocdir}/%{name}-apis');
    $jpp->get_section('files','jaxp-1.2-apis-javadoc')->subst(qr'%ghost %\{_javadocdir\}/\%\{name\}-apis','#%ghost %{_javadocdir}/%{name}-apis');
    $jpp->get_section('files','jaxp-1.1-apis-javadoc')->subst(qr'%ghost %\{_javadocdir\}/\%\{name\}-apis','#%ghost %{_javadocdir}/%{name}-apis');

    # from %post to %install (not to break provides)
    foreach my $sec ($jpp->get_sections()) {
	my $type=$sec->get_type();
	my $name=$sec->get_package();
	next if $name=~/javadoc$/;
	if ($type eq 'post' or $type eq 'postun') {
	    $sec->subst(qr'rm -f \%{_javadir}','#rm -f %{_javadir}');
	    $sec->subst(qr'ln -s \%{name}-jaxp-1','#ln -s %{name}-jaxp-1');
	}
    }
    $jpp->get_section('install')->push_body(q'
chmod 755 %buildroot%{_bindir}/*
');
    $jpp->get_section('files','jaxp-1.3-apis')->subst_if(qr'\%exclude ','',qr'{_javadir}/jaxp13.jar');
    $jpp->get_section('files','jaxp-1.2-apis')->subst_if(qr'\%exclude ','',qr'{_javadir}/jaxp12.jar');
    $jpp->get_section('files','jaxp-1.1-apis')->subst_if(qr'\%exclude ','',qr'{_javadir}/jaxp11.jar');
}

__END__
# from %post to %install (not to break provides)
%post jaxp-1.1-apis
#rm -f %{_javadir}/xml-commons-apis.jar
rm -f %{_javadir}/jaxp11.jar
ln -s %{name}-jaxp-1.1-apis.jar %{_javadir}/jaxp11.jar

%postun jaxp-1.1-apis
  rm -f %{_javadir}/jaxp11.jar

%post jaxp-1.2-apis
rm -f %{_javadir}/xml-commons-apis.jar
rm -f %{_javadir}/jaxp12.jar
ln -s %{name}-jaxp-1.2-apis.jar %{_javadir}/jaxp12.jar

%postun jaxp-1.2-apis
  rm -f %{_javadir}/jaxp12.jar

%postun jaxp-1.2-apis-javadoc
  rm -f %{_javadocdir}/%{name}-jaxp-1.2-apis

%post jaxp-1.3-apis
rm -f %{_javadir}/xml-commons-apis.jar
rm -f %{_javadir}/jaxp13.jar
ln -s %{name}-jaxp-1.3-apis.jar %{_javadir}/jaxp13.jar

%postun jaxp-1.3-apis
  rm -f %{_javadir}/jaxp13.jar
