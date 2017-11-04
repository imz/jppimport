#!/usr/bin/perl -w

require 'set_osgi.pl';
require 'add_missingok_config.pl';

push @SPECHOOKS, sub {
    my ($spec, $parent) = @_;
    &add_missingok_config($spec, '/etc/default/jetty','');

    $spec->get_section('files','')->subst_body_if(qr'^#\%ghost','%ghost',qr'\%\{rundir\}');

    my $initN=$spec->add_source('jetty.init');
    $spec->get_section('install')->push_body('install -D -m 755 %{S:'.$initN.'} %buildroot%_initdir/%name'."\n");
    $spec->get_section('files','')->push_body('%_initdir/%name'."\n");

    $spec->get_section('pre','')->subst_body(qr'-(?:g|u)\s+\%jtuid','');
    $spec->get_section('pre','')->subst_body(qr'-s\s+/sbin/nologin','-s /bin/sh');
    my $postun=$spec->get_section('postun','');
    if ($postun) {
	$postun->subst_body(qr'^userdel','# userdel');
	$postun->subst_body(qr'^groupdel','# groupdel');
    }
}
__END__
TODO: apply










   $spec->apply_to_sources(SOURCEFILE=>'jetty.init', PATCHFILE=>'jetty.init.diff');
    #if ($spec->get_section('package','')->match_body(qr'Source7:\s+jetty.init\s*$')) {
    #	$spec->get_section('prep')->push_body("sed -i 's,daemon --user,start_daemon --user,' %SOURCE7"."\n");
    #}



    # TODO fix in import
    #предупреждение: Macro %__fe_groupadd not found
    #предупреждение: Macro %__fe_useradd not found
    #предупреждение: Macro %__fe_userdel not found
    #предупреждение: Macro %__fe_groupdel not found
    # BuildRequires:\s+fedora-usermgmt-devel
    $spec->get_section('package','')->subst_body(qr'BuildRequires:\s+fedora-usermgmt-devel','');
    $spec->applied_block(
	"tmp hack TODO fix in import",
	sub {
	    foreach my $section ($spec->get_sections()) {
		if ($section->get_type() =~ '^(pre|post)') {
		    $section->subst_body(qr'\%__fe_','');
		    $section->subst_body(qr'fedora-user','user');
		    $section->subst_body(qr'fedora-group','group');
		}
	    }
	}
	);

