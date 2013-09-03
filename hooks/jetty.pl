#!/usr/bin/perl -w

require 'set_osgi.pl';
require 'set_fix_homedir_macro.pl';
require 'add_missingok_config.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    &add_missingok_config($jpp, '/etc/default/jetty8','');

    if ($jpp->main_section->get_tag('Version') eq '8.1.5') {
	# TODO drop jetty-orbit-maven-depmap when it will be deprecated
	$jpp->get_section('package','')->unshift_body('BuildRequires: jetty-orbit-maven-depmap
Requires: jetty-orbit-maven-depmap'."\n");
	# tmp
	$jpp->get_section('package','')->unshift_body('BuildRequires: eclipse-equinox-osgi felix-osgi-foundation xpp3-minimal maven-antrun-plugin eclipse-jdt'."\n") ;
    }

    $jpp->get_section('files','')->subst_body_if(qr'^#\%ghost','%ghost',qr'\%{rundir}');

    my $initN=$jpp->add_source('jetty.init');
    $jpp->get_section('install')->push_body('install -D -m 755 %{S:'.$initN.'} %buildroot%_initdir/%name'."\n");
    $jpp->get_section('files','')->push_body('%_initdir/%name'."\n");

    $jpp->get_section('pre','')->subst_body(qr'-(?:g|u)\s+\%jtuid','');
    $jpp->get_section('pre','')->subst_body(qr'-s\s+/sbin/nologin','-s /bin/sh');
    my $postun=$jpp->get_section('postun','');
    if ($postun) {
	$postun->subst_body(qr'^userdel','# userdel');
	$postun->subst_body(qr'^groupdel','# groupdel');
    }
}
__END__
TODO: apply










   $jpp->apply_to_sources(SOURCEFILE=>'jetty.init', PATCHFILE=>'jetty.init.diff');
    #if ($jpp->get_section('package','')->match_body(qr'Source7:\s+jetty.init\s*$')) {
    #	$jpp->get_section('prep')->push_body("sed -i 's,daemon --user,start_daemon --user,' %SOURCE7"."\n");
    #}



    # TODO fix in import
    #предупреждение: Macro %__fe_groupadd not found
    #предупреждение: Macro %__fe_useradd not found
    #предупреждение: Macro %__fe_userdel not found
    #предупреждение: Macro %__fe_groupdel not found
    # BuildRequires:\s+fedora-usermgmt-devel
    $jpp->get_section('package','')->subst(qr'BuildRequires:\s+fedora-usermgmt-devel','');
    $jpp->applied_block(
	"tmp hack TODO fix in import",
	sub {
	    foreach my $section ($jpp->get_sections()) {
		if ($section->get_type() =~ '^(pre|post)') {
		    $section->subst(qr'\%__fe_','');
		    $section->subst(qr'fedora-user','user');
		    $section->subst(qr'fedora-group','group');
		}
	    }
	}
	);

