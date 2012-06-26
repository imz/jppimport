#!/usr/bin/perl -w

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
    $jpp->get_section('package','javamail')->subst_if(qr'>=\s+0:1.0.1-5jpp','',qr'Requires');

    foreach my $pkg (keys(%pkg_rename)) {
	print "renaming: $pkg -> $pkg_rename{$pkg}\n";
	$jpp->get_section('package',"-n ".$pkg)->push_body('Provides: '.$pkg_rename{$pkg}.' = %{epoch}:%version-%release
Obsoletes: '.$pkg_rename{$pkg}.' < 1.8.0
');
    }
    $jpp->get_section('package','manual')->push_body('Provides: ant-task-reference = %{epoch}:%version-%release
Obsoletes: ant-task-reference < 1.8.0
');

    # add compat jarmaps
    $jpp->get_section('install')->map_body(
	sub{
	    if (/^\%add_to_maven_depmap org.apache.ant\s/) {
		my $old=$_;
		s/^\%add_to_maven_depmap org.apache.ant\s/\%add_to_maven_depmap ant /;
		$_=$old.$_;
	    }
	});


}



__END__
#extra alt packages
ant-jai
ant-stylebook
ant-optional
# subpackages
ant-style-xsl
# TODO: merge with manual
ant-task-reference
