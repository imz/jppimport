#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($spec,) = @_;
    my $manualsec=$spec->get_section('files','manual');
    $manualsec//=$spec->get_section('files','guide');
    if ($manualsec) {
	$spec->applied_block(
	    "set_manual_no_dereference hook",
	    sub {
		$manualsec->map_body(
		sub {
		s,^(\s*\%doc\s+)(manual|docs|documentation|target/dist|build/docs|build/javadocs|dist/docs),$1--no-dereference $2,;
		s,^\s*\%doc\s+(?=(?:tmp~/)?docs),%doc --no-dereference ,;
		});
	    }
	    );
    } else {
	die "\%files manual not found!\n";
    }
}
;

__END__
# push @SPECHOOKS, sub {
#     my ($spec,) = @_;
#     my $manualsec=$spec->get_section('files','manual');
#     if ($manualsec) {
# 	$spec->clear_applied();
# 	$spec->applied_off();
# 	$manualsec->subst_body(qr'^\s*%doc\s+target/dist','%doc --no-dereference target/dist');
# 	$manualsec->subst_body(qr'^\s*%doc\s+build/docs','%doc --no-dereference build/docs');
# 	$manualsec->subst_body(qr'^\s*%doc\s+build/javadocs','%doc --no-dereference build/javadocs');
# 	$manualsec->subst_body(qr'^\s*%doc\s+dist/docs','%doc --no-dereference dist/docs');
# 	$manualsec->subst_body(qr'^\s*%doc\s+docs/','%doc --no-dereference docs/');
# 	$spec->applied_on();
# 	$spec->report_applied_flags("set_manual_no_dereference hook");
#     } else {
# 	die "\%files manual not found!\n";
#     }
# }
#;
