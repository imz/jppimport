#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    # add compat jarmaps
    $jpp->get_section('install')->map_body(
	sub{
	    if (/^\%add_to_maven_depmap org.apache.velocity\s/) {
		my $old=$_;
		s/^\%add_to_maven_depmap org.apache.velocity\s/\%add_to_maven_depmap velocity /;
		$_=$old.$_;
	    }
	});

}

__END__
