#!/usr/bin/perl -w

push @SPECHOOKS, \&set_target_14;

sub set_target_14 {
    my ($spec, $parent) = @_;
    my $target='1.4';
    return if $spec->{__::HOOKS::set_target};
    $spec->{__::HOOKS::set_target}=1;
	$spec->applied_block(
	"set_target_$target hook",
	sub {
    $spec->get_section('prep')->subst(qr'^export JAVA_HOME=','#export JAVA_HOME=');
    $spec->get_section('build')->subst(qr'^export JAVA_HOME=','#export JAVA_HOME=');
    $spec->get_section('package')->subst(qr'jpackage-compat','jpackage-1.6-compat') if $target eq '1.5';
    $spec->clear_applied();
    $spec->get_section('prep')->subst(qr'^(\s*\%?\{?ant\}?\s)',"ant -Dant.build.javac.source=$target -Dant.build.javac.target=$target ");
    $spec->get_section('build')->subst(qr'^(\s*\%?\{?ant\}?\s)',"ant -Dant.build.javac.source=$target -Dant.build.javac.target=$target ");
    $spec->get_section('prep')->subst(qr'^\s*mvn(?=\s|$)',"mvn -Dmaven.compile.target=$target -Dmaven.javadoc.source=$target ");
    $spec->get_section('build')->subst(qr'^\s*mvn(?=\s|$)',"mvn -Dmaven.compile.target=$target -Dmaven.javadoc.source=$target ");
    $spec->get_section('prep')->subst(qr'^\s*mvn-jpp(?=\s|$)',"mvn-jpp -Dmaven.compile.target=$target -Dmaven.javadoc.source=$target ");
    $spec->get_section('build')->subst(qr'^\s*mvn-jpp(?=\s|$)',"mvn-jpp -Dmaven.compile.target=$target -Dmaven.javadoc.source=$target ");
    $spec->get_section('prep')->subst(qr'bin/javac ',"bin/javac  -target $target -source $target ");
    $spec->get_section('build')->subst(qr'bin/javac ',"bin/javac  -target $target -source $target ");
	    });
}
