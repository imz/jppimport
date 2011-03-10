#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
};
__END__
# eclipse-checkstyle 4.1
    $jpp->get_section('package','')->subst(qr' cs_ver 4.1',' cs_ver 4.4');
    $jpp->get_section('package','')->subst_if(qr'checkstyle','checkstyle4',qr'Requires:');
    foreach my $sec ($jpp->get_section('build'),$jpp->get_section('install')) {
	$sec->subst(qr'checkstyle-optional-\%{cs_ver}','checkstyle4-optional-%{cs_ver}');
	$sec->subst(qr'checkstyle-\%{cs_ver}','checkstyle4-%{cs_ver}');
    }
