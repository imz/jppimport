#!/usr/bin/perl -w

push @SPECHOOKS, \&set_maven1_target_14;

sub set_maven1_target_14 {
    my ($jpp, $alt) = @_;
	$jpp->applied_block(
	"set_maven1_target_14 hook",
	sub {
    $jpp->get_section('build')->subst(qr'^export JAVA_HOME=/usr/lib/jvm/java-1.4.2','#export JAVA_HOME=/usr/lib/jvm/java-1.4.2');
    $jpp->clear_applied();
    $jpp->get_section('prep')->subst(qr'^\s*maven(?=\s|$)','maven -Dmaven.compile.target=1.4 -Dmaven.javadoc.source=1.4 ');
    $jpp->get_section('build')->subst(qr'^\s*maven(?=\s|$)','maven -Dmaven.compile.target=1.4 -Dmaven.javadoc.source=1.4 ');
	    });
}
