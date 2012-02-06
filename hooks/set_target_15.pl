#!/usr/bin/perl -w

push @SPECHOOKS, \&set_target_15;

my $build_repo_mode;

sub section_set_target {
    my ($jpp,$secname,$target)=@_;
    my $section=$jpp->get_section($secname);
    return unless $section;
    $build_repo_mode=0;
    $section->map_body(
	sub {
	    if (/build-jar-repository.*\\$/) {
		$build_repo_mode=1;
		return;
	    }
	    if ($build_repo_mode) {
		$build_repo_mode=0 unless /\\$/;
		return;
	    }
	    return if /build-(?:jar-repository|classpath)/;

	    s!bin/javac !bin/javac  -target $target -source $target ! or
	    s!%{javac} !%{javac}  -target $target -source $target ! or
	    s!^\s*mvn(?=\s|$)!mvn -Dmaven.compile.target=$target -Dmaven.javadoc.source=$target ! or
	    s!^\s*(?:\%{_bindir}/)?mvn-jpp(?=\s|$)!mvn-jpp -Dmaven.compile.target=$target -Dmaven.javadoc.source=$target ! or
	    s!^\s*(?:\%{_bindir}/)?maven(?=\s|$)!maven -Dmaven.compile.target=$target -Dmaven.javadoc.source=$target ! or
	    s!^(\s*\%?\{?ant(?:17)?\}?\s)!$1 -Dant.build.javac.source=$target -Dant.build.javac.target=$target !;
	})
}


sub set_target_15 {
    my ($jpp, $alt) = @_;
    my $target='1.5';
    return if $jpp->{__::HOOKS::set_target};
    my $prepsec=$jpp->get_section('prep');
    my $buildsec=$jpp->get_section('build');
    if ($buildsec and $buildsec->match_body(qr'-Dmaven.compile.target') || $buildsec->match_body(qr'-Dant.build.javac.source')) {
	warn "target hook detected\n";
	return;
    }
    $jpp->{__::HOOKS::set_target}=1;
	$jpp->applied_block(
	"set_target_$target hook",
	sub {
    $prepsec->subst(qr'^export JAVA_HOME=','#export JAVA_HOME=') if $prepsec;
    $buildsec->subst(qr'^export JAVA_HOME=','#export JAVA_HOME=') if $buildsec;
#    $jpp->get_section('package')->subst(qr'jpackage-compat','jpackage-1.6-compat') if $target eq '1.5';
    $jpp->clear_applied();
    &section_set_target($jpp,'prep',$target);
    &section_set_target($jpp,'build',$target);

    # tomcat 5 :( but breaks felix :(
    $jpp->get_section('install')->subst(qr'^(\s*\%?\{?ant\}?\s)',"ant -Dant.build.javac.source=$target -Dant.build.javac.target=$target ") if $jpp->main_section->get_tag('Name') eq 'tomcat5';


	    });
};

1;
