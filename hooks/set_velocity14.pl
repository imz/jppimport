#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;

    # it provides velocity, so nothing should be installed?
    $jpp->get_section('package','')->unshift_body('BuildRequires(pre): velocity14'."\n");


#    $jpp->get_section('build')->unshift_body(q!
## hack used to build ehcache w/velocity 1.4
#mkdir -p .m2/repository/velocity/velocity/1.4
#ln -s /usr/share/java/velocity14.jar .m2/repository/velocity/velocity/1.4/velocity-1.4.jar
#!);

    foreach my $section ($jpp->get_sections()) {
	if ($section->get_type() eq 'package') {
	    #$section->subst_if(qr'velocity','velocity14',qr'Requires:');
	    $section->subst_if(qr'velocity(?=(?:\s|$))',  'velocity14 ', qr'Requires:');
	}
    }
    $jpp->get_section('prep')->subst('build-classpath\s+velocity','build-classpath velocity14');
    $jpp->get_section('build')->subst('build-classpath\s+velocity','build-classpath velocity14');
};

__END__
