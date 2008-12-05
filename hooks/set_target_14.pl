#!/usr/bin/perl -w

push @SPECHOOKS, \&set_target_14;

sub set_target_14 {
    my ($jpp, $alt) = @_;
	$jpp->applied_block(
	"set_target_14 hook",
	sub {
    $jpp->get_section('build')->subst(qr'^export JAVA_HOME=/usr/lib/jvm/java-1.4.2','#export JAVA_HOME=/usr/lib/jvm/java-1.4.2');
    $jpp->clear_applied();
    $jpp->get_section('prep')->subst(qr'^(\s*\%?ant\s)','ant -Dant.build.javac.source=1.4 -Dant.build.javac.target=1.4 ');
    $jpp->get_section('build')->subst(qr'^(\s*\%?ant\s)','ant -Dant.build.javac.source=1.4 -Dant.build.javac.target=1.4 ');
    $jpp->get_section('prep')->subst(qr'^\s*mvn(?=\s|$)','mvn -Dmaven.compile.target=1.4 -Dmaven.javadoc.source=1.4 ');
    $jpp->get_section('build')->subst(qr'^\s*mvn(?=\s|$)','mvn -Dmaven.compile.target=1.4 -Dmaven.javadoc.source=1.4 ');
    $jpp->get_section('prep')->subst(qr'^\s*mvn-jpp(?=\s|$)','mvn-jpp -Dmaven.compile.target=1.4 -Dmaven.javadoc.source=1.4 ');
    $jpp->get_section('build')->subst(qr'^\s*mvn-jpp(?=\s|$)','mvn-jpp -Dmaven.compile.target=1.4 -Dmaven.javadoc.source=1.4 ');
	    });
}
