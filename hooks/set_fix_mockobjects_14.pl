#!/usr/bin/perl -w

push @SPECHOOKS, \&set_fix_mockobects_14;

sub set_fix_mockobects_14 {
    my ($jpp, $alt) = @_;
	$jpp->applied_block(
	"set_fix_mockobects_14 hook",
	sub {
	    $jpp->get_section('prep')->subst_if(qr'mockobjects-j2ee1.4','mockobjects-jdk1.4-j2ee1.4',qr'build-classpath');
	    $jpp->get_section('prep')->subst_if(qr'mockobjects-alt','mockobjects-alt-jdk1.4',qr'build-classpath');
	    $jpp->get_section('prep')->subst_if(qr'mockobjects(?=[\s)])','mockobjects-jdk1.4',qr'build-classpath');
	    $jpp->get_section('build')->subst_if(qr'mockobjects-j2ee1.4','mockobjects-jdk1.4-j2ee1.4',qr'build-classpath');
	    $jpp->get_section('build')->subst_if(qr'mockobjects-alt','mockobjects-alt-jdk1.4',qr'build-classpath');
	    $jpp->get_section('build')->subst_if(qr'mockobjects(?=[\s)])','mockobjects-jdk1.4',qr'build-classpath');
	    });
}
