#!/usr/bin/perl -w

require 'set_fix_homedir_macro.pl';
require 'add_missingok_config.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    &add_missingok_config($jpp, '/etc/default/jetty8','');

    # tmp
    $jpp->get_section('package','')->unshift_body('BuildRequires: eclipse-equinox-osgi felix-osgi-foundation xpp3-minimal'."\n") if $jpp->main_section->get_tag('Version') eq '8.1.5';

    my $initN=$jpp->add_source('jetty.init');
    $jpp->get_section('install')->push_body('install -D -m 755 %{S:'.$initN.'} %buildroot%_initdir/%name'."\n");
    $jpp->get_section('files','')->push_body('%_initdir/%name'."\n");


    #$jpp->get_section('pre','')->subst_body(qr'-(?:g|u)\s+\%jtuid','');
    $jpp->get_section('postun','')->subst_body(qr'^userdel','# userdel');
    $jpp->get_section('postun','')->subst_body(qr'^groupdel','# groupdel');
    $jpp->spec_apply_patch(PATCHSTRING=>q! https://bugzilla.altlinux.org/show_bug.cgi?id=27671
--- jetty.spec.0	2012-09-20 19:54:57.555610814 +0000
+++ jetty.spec	2012-09-20 20:00:28.175148353 +0000
@@ -851,9 +851,9 @@
 
 
 %pre
-(getent group  %username || groupadd -r  %username) &>/dev/null || :
-(getent passwd %username || useradd  -r  -g %username -d %apphomedir \
-                              -M -s /sbin/nologin %username) &>/dev/null || :
+getent group %username >/dev/null || groupadd -r  %username || :
+getent passwd %username >/dev/null || useradd -r  -g %username -d %apphomedir \
+                              -M -s /bin/sh %username || :
 
 %postun
 # userdel  %username &>/dev/null || :

			   !);

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

