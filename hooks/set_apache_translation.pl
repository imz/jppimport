#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;

    $jpp->applied_block(
	"apache->jakarta translation hook",
	sub {
	    foreach my $section ($jpp->get_sections()) {
		next if $section->get_type() ne 'package';
		$section->subst_if(qr'apache-commons-dbcp', 'jakarta-commons-dbcp',qr'Requires');
		$section->subst_if(qr'apache-commons-fileupload', 'jakarta-commons-fileupload',qr'Requires');
		$section->subst_if(qr'apache-commons-httpclient', 'jakarta-commons-httpclient',qr'Requires');
		$section->subst_if(qr'apache-commons-io', 'jakarta-commons-io',qr'Requires');
#		$section->subst_if(qr'apache-commons-lang', 'jakarta-commons-lang',qr'Requires');
		$section->subst_if(qr'apache-commons-logging', 'jakarta-commons-logging',qr'Requires');
		$section->subst_if(qr'apache-commons-net', 'jakarta-commons-net',qr'Requires');
		$section->subst_if(qr'apache-commons-pool', 'jakarta-commons-pool',qr'Requires');
		$section->subst_if(qr'apache-commons-validator', 'jakarta-commons-validator',qr'Requires');
		$section->subst_if(qr'apache-commons-vfs', 'jakarta-commons-vfs',qr'Requires');
#		$section->subst_if(qr'apache-commons-', 'jakarta-commons-',qr'Requires');
	    }
	}
	);

}



__END__
