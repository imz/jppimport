#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    # homedir confilct (TODO: report)
    $jpp->applied_block(
	"homedir confilct",
	sub {
#	    map {$_->subst(qr'homedir','apphomedir')} $jpp->get_sections();
watn "Oops! fix_homedir_macro: I am deprecated! KILL ME APSTENU!!!\n"
	});
};

1;
