#!/usr/bin/perl -w

push @SPECHOOKS, \&set_target_18;

sub section_set_target {
    my ($spec,$secname,$target,$release)=@_;
    my $section=$spec->get_section($secname);
    return unless $section;
    my $already_set=0;
    $section->map_body(
	sub {
	    return if /^\s*#/;
	    # check for # ant -Djavac.source=1.8 -Djavac.target=1.8 too
	    $already_set=1 if /-D(?:ant\.build\.)?javac\.target=$target/;
	    if (/-Dmaven\.compiler\.target=$target/) {
		$already_set=1;
		unless (/-Dmaven\.compiler\.release=/) {
		    s,-Dmaven\.compiler\.target=$target,-Dmaven.compiler.target=$target -Dmaven.compiler.release=$release,;
		    warn 'INFO set_target: %',$secname,' target=',$target,' added release=',$release,"\n";
		}
	    }
	}
	);
    warn 'INFO set_target: %',$secname,' target=',$target,' already set',"\n" if $already_set;
    return if $already_set;
    my $build_repo_mode=0;
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
	    s!(\%(?:javac|\{javac\})) !$1 -target $target -source $target ! or
	    s!^javac !javac  -target $target -source $target ! or
	    s!(\%(?:javadoc|\{javadoc\})) !$1 -source $target ! or
	    #s!^\s*(?:\%\{_bindir\}/)?(maven|mvn|mvn-jpp|mvn-jpp22|mvn-rpmbuild)(?=\s|$)!$1 -Dmaven.compiler.source=$target -Dmaven.compiler.target=$target -Dmaven.javadoc.source=$target ! or
	    s!^(\s*\%mvn_build.*\s--\s)!$1-Dmaven.compiler.source=$target -Dmaven.compiler.target=$target -Dmaven.javadoc.source=$target -Dmaven.compiler.release=$release ! or
	    s!^(\s*\%mvn_build)(\s*$)!$1 -- -Dmaven.compiler.source=$target -Dmaven.compiler.target=$target -Dmaven.javadoc.source=$target -Dmaven.compiler.release=$release$2! or
	    s!^(\s*\%mvn_build(?:\s+-[-\w]+)+)(\s*$)!$1 -- -Dmaven.compiler.source=$target -Dmaven.compiler.target=$target -Dmaven.javadoc.source=$target -Dmaven.compiler.release=$release$2! or
	    s!^(\s*\%?\{?ant(?:18)?\}?)(?=\s)!$1 -Dant.build.javac.source=$target -Dant.build.javac.target=$target !;
	})
}


sub set_target_18 {
    my ($spec,) = @_;
    my $target='1.8';
    my $release='8';
    return if $spec->{__::HOOKS::set_target};
    my $prepsec=$spec->get_section('prep');
    my $buildsec=$spec->get_section('build');
#    if ($buildsec and $buildsec->match_body(qr'-Dmaven.compile.target') || $buildsec->match_body(qr'-Dmaven.compiler.target') || $buildsec->match_body(qr'-Dant.build.javac.source')) {
#	warn "target hook detected\n";
#	return;
#    }
    $spec->{__::HOOKS::set_target}=1;
	$spec->applied_block(
	"set_target_$target hook",
	sub {
    $prepsec->subst_body(qr'^export JAVA_HOME=','#export JAVA_HOME=') if $prepsec;
    $buildsec->subst_body(qr'^export JAVA_HOME=','#export JAVA_HOME=') if $buildsec;
#    $spec->get_section('package')->subst_body(qr'jpackage-compat','jpackage-1.7-compat') if $target eq '1.7';
    $spec->clear_applied();
    &section_set_target($spec,'prep',$target,$release);
    &section_set_target($spec,'build',$target,$release);

	    });
};

1;
