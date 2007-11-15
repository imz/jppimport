#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    #$jpp->get_section('package','')->subst(qr'mysql-connector-java','mysql-connector-jdbc');
    foreach my $section (@{$jpp->get_sections()}) {
	if ($section->get_type() eq 'package') {
	    $section->subst(qr'hsqldb\s*>=\s*0:1.72','hsqldb');
	}
    }

#    $jpp->get_section('package','')->unshift_body('BuildRequires(pre): j2se-jdbc'."\n");
};

1;
