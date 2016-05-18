#!/usr/bin/perl -w

require 'set_osgi_fc.pl';

push @SPECHOOKS, 
sub {
    my ($spec, ) = @_;
    my $filesec=$spec->get_section('files','');
    $spec->get_section('package','')->unshift_body('%define _libexecdir %_prefix/libexec'."\n");
    my $initN=$spec->add_source('tomcat.init');
    $spec->get_section('install')->push_body('install -D -m 755 %{S:'.$initN.'} %buildroot%_initdir/%name'."\n");
    $filesec->push_body('%attr(0755,root,root) %_initdir/%name'."\n");

    # see https://bugzilla.altlinux.org/show_bug.cgi?id=31853#c20
    $spec->source_apply_patch(PATCHFILE=>'tomcat-8.0.logrotate.diff',SOURCEFILE=>'tomcat-8.0.logrotate');
    my $sysVwrapper=$spec->add_source('tomcat-sysv.wrapper');
    $spec->get_section('install')->push_body('install -D -m 755 %{S:'.$sysVwrapper.'} %buildroot%_sbindir/%{name}-sysv'."\n");
    $filesec->push_body('%attr(0755,root,root) %_sbindir/%{name}-sysv'."\n");

    $spec->get_section('package','')->unshift_body('# fc script use systemctl calls -- gives dependency on systemctl :(
%add_findreq_skiplist %{_sbindir}/tomcat'."\n");

    # sisyphus_check
    $filesec->subst_body(qr'0664,root,tomcat','0644,root,tomcat');
    $filesec->subst_body(qr'0664,tomcat,tomcat','0644,tomcat,tomcat');
    $filesec->subst_body(qr'0660,tomcat,tomcat','0640,tomcat,tomcat');
    $filesec->subst_body(qr'^\%doc','%attr(0755,root,root) %doc');
    $filesec->push_body('%attr(0755,root,root) %dir %{bindir}'."\n");
#   $filesec->subst_body(qr'^\%{bindir}/','%attr(0644,root,root) %{bindir}/');
    $filesec->subst_body(qr'^\%dir %{apphomedir}','%attr(0755,root,root) %dir %{apphomedir}');
};

__END__
