#!/usr/bin/perl -w

push @SPECHOOKS, \&set_target_15;

sub set_target_15 {
    my ($jpp, $alt) = @_;
	$jpp->applied_block(
	"set_target_15 hook",
	sub {
    $jpp->get_section('prep')->subst(qr'^export JAVA_HOME=','#export JAVA_HOME=');
    $jpp->get_section('build')->subst(qr'^export JAVA_HOME=','#export JAVA_HOME=');
    $jpp->clear_applied();
    $jpp->get_section('prep')->subst(qr'^(\s*\%?ant\s)','ant -Dant.build.javac.source=1.5 -Dant.build.javac.target=1.5 ');
    $jpp->get_section('build')->subst(qr'^(\s*\%?ant\s)','ant -Dant.build.javac.source=1.5 -Dant.build.javac.target=1.5 ');
    $jpp->get_section('prep')->subst(qr'^\s*mvn(?=\s|$)','mvn -Dmaven.compile.target=1.5 -Dmaven.javadoc.source=1.5 ');
    $jpp->get_section('build')->subst(qr'^\s*mvn(?=\s|$)','mvn -Dmaven.compile.target=1.5 -Dmaven.javadoc.source=1.5 ');
    $jpp->get_section('prep')->subst(qr'^\s*mvn-jpp(?=\s|$)','mvn-jpp -Dmaven.compile.target=1.5 -Dmaven.javadoc.source=1.5 ');
    $jpp->get_section('build')->subst(qr'^\s*mvn-jpp(?=\s|$)','mvn-jpp -Dmaven.compile.target=1.5 -Dmaven.javadoc.source=1.5 ');
    $jpp->get_section('prep')->subst(qr'bin/javac ','bin/javac  -target 1.5 -source 1.5 ');
    $jpp->get_section('build')->subst(qr'bin/javac ','bin/javac  -target 1.5 -source 1.5 ');
	    });
}
