#!/usr/bin/perl -w

push @SPECHOOKS, 

sub {
    my ($jpp, $alt) = @_;
    # hmm... is it will be runtime compatible? test...
    $jpp->get_section('package','')->unshift_body('BuildRequires(pre): velocity14'."\n");
    $jpp->get_section('build')->unshift_body(q!
# hack used to build ehcache w/velocity 1.4
mkdir -p .m2/repository/velocity/velocity/1.4
ln -s /usr/share/java/velocity-1.4.jar .m2/repository/velocity/velocity/1.4/
!);

    foreach my $section (@{$jpp->get_sections_ref()}) {
	if ($section->get_type() eq 'package') {
	    $section->subst_if(qr'velocity','velocity14',qr'Requires:');
	}
    }

    $jpp->get_section('prep')->subst('build-classpath\s+velocity','build-classpath velocity-1.4');
    $jpp->get_section('build')->subst('build-classpath\s+velocity','build-classpath velocity-1.4');
}

__END__
