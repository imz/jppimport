#!/usr/bin/perl -w

push @SPECHOOKS, \&set_target_17;

my $build_repo_mode;

sub section_set_target {
    my ($spec,$secname,$target)=@_;
    my $section=$spec->get_section($secname);
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
	    s!\%\{javac\} !%{javac}  -target $target -source $target ! or
	    s!^javac !javac  -target $target -source $target ! or
	    s!^\s*(?:\%\{_bindir\}/)?(maven|mvn|mvn-jpp|mvn-jpp22|mvn-rpmbuild)(?=\s|$)!$1 -Dmaven.compile.source=1.7 -Dmaven.compile.target=$target -Dmaven.javadoc.source=$target ! or
	    s!^(\s*\%?\{?ant(?:17)?\}?)(?=\s)!$1 -Dant.build.javac.source=$target -Dant.build.javac.target=$target !;
	})
}


sub set_target_17 {
    my ($spec, $parent) = @_;
    my $target='1.7';
    return if $spec->{__::HOOKS::set_target};
    my $prepsec=$spec->get_section('prep');
    my $buildsec=$spec->get_section('build');
    if ($buildsec and $buildsec->match_body(qr'-Dmaven.compile.target') || $buildsec->match_body(qr'-Dant.build.javac.source')) {
	warn "target hook detected\n";
	return;
    }
    $spec->{__::HOOKS::set_target}=1;
	$spec->applied_block(
	"set_target_$target hook",
	sub {
    $prepsec->subst_body(qr'^export JAVA_HOME=','#export JAVA_HOME=') if $prepsec;
    $buildsec->subst_body(qr'^export JAVA_HOME=','#export JAVA_HOME=') if $buildsec;
#    $spec->get_section('package')->subst_body(qr'jpackage-compat','jpackage-1.7-compat') if $target eq '1.7';
    $spec->clear_applied();
    &section_set_target($spec,'prep',$target);
    &section_set_target($spec,'build',$target);

    # tomcat 5 :( but breaks felix :(
    $spec->get_section('install')->subst_body(qr'^(\s*\%?\{?ant\}?\s)',"ant -Dant.build.javac.source=$target -Dant.build.javac.target=$target ") if $spec->main_section->get_tag('Name') eq 'tomcat5';


	    });
};

1;
