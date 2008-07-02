#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    my $manualsec=$jpp->get_section('files','manual');
    if ($manualsec) {
	$manualsec->subst(qr'^\s*%doc\s+target/dist','%doc --no-dereference target/dist');
	$manualsec->subst(qr'^\s*%doc\s+build/docs','%doc --no-dereference build/docs');
	$manualsec->subst(qr'^\s*%doc\s+build/javadocs','%doc --no-dereference build/javadocs');
	$manualsec->subst(qr'^\s*%doc\s+dist/docs','%doc --no-dereference dist/docs');
	$manualsec->subst(qr'^\s*%doc\s+docs/','%doc --no-dereference docs/');
    } else {
	die "\%files manual not found!\n";
    }
}
;
