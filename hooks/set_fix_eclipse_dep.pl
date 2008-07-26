#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    # homedir confilct (TODO: report)
    foreach (@{$jpp->get_sections_ref()}) {
	if ($_->get_type() eq 'package') {
	    $_->subst_if(qr'1:3.3(.\d)?','0:3.3', qr'Requires:.+eclipse');
	    $_->subst_if(qr'1:3.2(.\d)?','0:3.3', qr'Requires:.+eclipse');
	    $_->subst_if(qr'3.3.1','3.3', qr'Requires:.+eclipse');
	    $_->subst_if(qr'1:%{eclipse_ver}','0:%{eclipse_ver}', qr'Requires:.+eclipse');
	}
    }

};

1;
