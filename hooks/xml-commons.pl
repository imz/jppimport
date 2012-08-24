#!/usr/bin/perl -w

require 'set_add_fc_osgi_manifest.pl';

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    # alt sppecific - removed ghosted alternatives symlink
    $jpp->get_section('install')->subst(qr'ln -s %\{_sysconfdir\}/alternatives/%\{name\}-apis-javadoc \$RPM_BUILD_ROOT%\{_javadocdir\}/%\{name\}-apis','#ln -s %{_sysconfdir}/alternatives/%{name}-apis-javadoc $RPM_BUILD_ROOT%{_javadocdir}/%{name}-apis');
    $jpp->get_section('files','jaxp-1.1-apis-javadoc')->exclude(qr'\%{_javadocdir}/\%{name}-apis');
    $jpp->get_section('files','jaxp-1.2-apis-javadoc')->exclude(qr'\%{_javadocdir}/\%{name}-apis');
    $jpp->get_section('files','jaxp-1.3-apis-javadoc')->exclude(qr'\%{_javadocdir}/\%{name}-apis');

    $jpp->get_section('package','')->subst_body(qr'global _extension \.gz','global _extension .bz2');

    $jpp->applied_block(
	"from %post to %install (not to break provides) hook",
	sub {
    # from %post to %install (not to break provides)
    foreach my $sec ($jpp->get_sections()) {
	my $type=$sec->get_type();
	my $name=$sec->get_raw_package();
	next if $name=~/javadoc$/;
	if ($type eq 'post' or $type eq 'postun') {
	    $sec->subst(qr'rm -f \%{_javadir}','#rm -f %{_javadir}');
	    $sec->subst(qr'ln -s \%{name}-jaxp-1','#ln -s %{name}-jaxp-1');
	}
    }

	});

    $jpp->get_section('install')->push_body(q'
chmod 755 %buildroot%{_bindir}/*
');
    $jpp->get_section('files','jaxp-1.3-apis')->subst_if(qr'\%exclude ','',qr'{_javadir}\*?/jaxp13.jar');
    $jpp->get_section('files','jaxp-1.2-apis')->subst_if(qr'\%exclude ','',qr'{_javadir}\*?/jaxp12.jar');
    $jpp->get_section('files','jaxp-1.1-apis')->subst_if(qr'\%exclude ','',qr'{_javadir}\*?/jaxp11.jar');

    #  ghost alternatives. as a hook?
    $jpp->applied_block(
	"ghost alternatives in bin hook",
	sub {
	    foreach my $sec ($jpp->get_sections()) {
		my $type=$sec->get_type();
		if ($type eq 'files') {
		    $sec->exclude(qr'\%attr\(0755,root,root\)\s+\%ghost\s+\%{_bindir}');
		}
	    }
	});

}

__END__

################################################
# DONE: what was moved
################################################
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

