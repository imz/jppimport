#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    my $manualsec=$jpp->get_section('files','manual');
    if ($manualsec) {
	$jpp->applied_block(
	    "set_manual_no_dereference hook",
	    sub {
		$manualsec->subst(qr'^\s*%doc\s+manual','%doc --no-dereference manual');
		$manualsec->subst(qr'^\s*%doc\s+target/dist','%doc --no-dereference target/dist');
		$manualsec->subst(qr'^\s*%doc\s+build/docs','%doc --no-dereference build/docs');
		$manualsec->subst(qr'^\s*%doc\s+build/javadocs','%doc --no-dereference build/javadocs');
		$manualsec->subst(qr'^\s*%doc\s+dist/docs','%doc --no-dereference dist/docs');
		$manualsec->subst(qr'^\s*%doc\s+(?=(?:tmp~/)?docs)','%doc --no-dereference ');
		#$manualsec->subst(qr'^\s*%doc\s+docs/','%doc --no-dereference docs/');
		$manualsec->subst(qr'^\s*%doc\s+/','%doc --no-dereference docs/');
	    }
	    );
    } else {
	die "\%files manual not found!\n";
    }
}
;

__END__
# push @SPECHOOKS, sub {
#     my ($jpp, $alt) = @_;
#     my $manualsec=$jpp->get_section('files','manual');
#     if ($manualsec) {
# 	$jpp->clear_applied();
# 	$jpp->applied_off();
# 	$manualsec->subst(qr'^\s*%doc\s+target/dist','%doc --no-dereference target/dist');
# 	$manualsec->subst(qr'^\s*%doc\s+build/docs','%doc --no-dereference build/docs');
# 	$manualsec->subst(qr'^\s*%doc\s+build/javadocs','%doc --no-dereference build/javadocs');
# 	$manualsec->subst(qr'^\s*%doc\s+dist/docs','%doc --no-dereference dist/docs');
# 	$manualsec->subst(qr'^\s*%doc\s+docs/','%doc --no-dereference docs/');
# 	$jpp->applied_on();
# 	$jpp->report_applied_flags("set_manual_no_dereference hook");
#     } else {
# 	die "\%files manual not found!\n";
#     }
# }
#;
