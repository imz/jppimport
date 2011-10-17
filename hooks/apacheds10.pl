#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->applied_block(
	"/var/name to /var/lib/name hook",
	sub {
	    map {
		$_->subst(qr'\%{_var}/\%{name}','/var/lib/%{name}');
	    } $jpp->get_sections();
	}
	);

#%pre server-main # not a system account!
    $jpp->get_section('pre','server-main')->subst(qr'groupadd', 'groupadd -r');
    $jpp->get_section('pre','server-main')->subst(qr'useradd', 'useradd -r');
    $jpp->copy_to_sources('apacheds10.init');
    $jpp->get_section('post','server-main')->exclude(qr'bcprov');

};

__END__
