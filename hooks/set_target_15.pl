#!/usr/bin/perl -w

push @SPECHOOKS, \&set_target_15;

sub set_target_15 {
    my ($jpp, $alt) = @_;
    my $target='1.5';
    return if $jpp->{__::HOOKS::set_target};
    $jpp->{__::HOOKS::set_target}=1;
	$jpp->applied_block(
	"set_target_$target hook",
	sub {
    $jpp->get_section('prep')->subst(qr'^export JAVA_HOME=','#export JAVA_HOME=');
    $jpp->get_section('build')->subst(qr'^export JAVA_HOME=','#export JAVA_HOME=');
#    $jpp->get_section('package')->subst(qr'jpackage-compat','jpackage-1.6-compat') if $target eq '1.5';
    $jpp->clear_applied();
    $jpp->get_section('prep')->subst(qr'^\s*\%?\{?ant\}?(?=\s)',"ant -Dant.build.javac.source=$target -Dant.build.javac.target=$target ");
    $jpp->get_section('build')->subst(qr'^\s*\%?\{?ant\}?(?=\s)',"ant -Dant.build.javac.source=$target -Dant.build.javac.target=$target ");
    # tomcat 5 :(
    $jpp->get_section('install')->subst(qr'^\s*\%?\{?ant\}?(?=\s)',"ant -Dant.build.javac.source=$target -Dant.build.javac.target=$target ");
    $jpp->get_section('prep')->subst(qr'^\s*\%?\{?ant17\}?(?=\s)',"ant17 -Dant.build.javac.source=$target -Dant.build.javac.target=$target ");
    $jpp->get_section('build')->subst(qr'^\s*\%?\{?ant17\}?(?=\s)',"ant17 -Dant.build.javac.source=$target -Dant.build.javac.target=$target ");
    $jpp->get_section('prep')->subst(qr'^\s*mvn(?=\s|$)',"mvn -Dmaven.compile.target=$target -Dmaven.javadoc.source=$target ");
    $jpp->get_section('build')->subst(qr'^\s*mvn(?=\s|$)',"mvn -Dmaven.compile.target=$target -Dmaven.javadoc.source=$target ");
    $jpp->get_section('prep')->subst(qr'^\s*(?:\%{_bindir}/)?mvn-jpp(?=\s|$)',"mvn-jpp -Dmaven.compile.target=$target -Dmaven.javadoc.source=$target ");
    $jpp->get_section('build')->subst(qr'^\s*(?:\%{_bindir}/)?mvn-jpp(?=\s|$)',"mvn-jpp -Dmaven.compile.target=$target -Dmaven.javadoc.source=$target ");
    $jpp->get_section('prep')->subst(qr'^\s*(?:\%{_bindir}/)?maven(?=\s|$)',"maven -Dmaven.compile.target=$target -Dmaven.javadoc.source=$target ");
    $jpp->get_section('build')->subst(qr'^\s*(?:\%{_bindir}/)?maven(?=\s|$)',"maven -Dmaven.compile.target=$target -Dmaven.javadoc.source=$target ");
    $jpp->get_section('prep')->subst(qr'bin/javac ',"bin/javac  -target $target -source $target ");
    $jpp->get_section('build')->subst(qr'bin/javac ',"bin/javac  -target $target -source $target ");
    $jpp->get_section('prep')->subst(qr'%{javac} ',"%{javac}  -target $target -source $target ");
    $jpp->get_section('build')->subst(qr'%{javac} ',"%{javac}  -target $target -source $target ");
	    });
}
