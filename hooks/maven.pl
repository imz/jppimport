#!/usr/bin/perl -w

require 'add_missingok_config.pl';

push @SPECHOOKS, 
sub {
    my ($spec,) = @_;

    # Следующие пакеты имеют неудовлетворенные зависимости:
    # maven: Требует: /etc/mavenrc но пакет не может быть установлен
    &add_missingok_config($spec,'/etc/mavenrc');
    &add_missingok_config($spec,'/etc/java/maven.conf');

    # alternatively
    # for /etc/mavenrc
    #%add_findreq_skiplist /usr/share/maven/bin/*

    # deprecated?
    $spec->add_section('pre','')->push_body(q'# https://bugzilla.altlinux.org/show_bug.cgi?id=27807 (upgrade from maven1)
[ -d %_datadir/maven/repository/JPP ] && rm -rf %_datadir/maven/repository/JPP ||:'."\n");

    $spec->spec_apply_patch(PATCHFILE => 'maven.spec.diff');
warn "==============================================================
#
#
#--------------------------- OOPS! new maven alternatives! 
#
#
#
#
#
#
#
#
#   move to maven-lib (or will not work!)
#   and fix post/un scripts!!!
#
#   !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#
#
#   !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#
#
#   !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#
#######################################################
"
};

push @PREHOOKS, 
sub {
    my ($spec,) = @_;
    # maven-filesystem
    $spec->get_section('package','')->push_body(q!# maven-filesystem
Requires: maven-filesystem
BuildArch: noarch
!."\n");
    $spec->get_section('install')->push_body(q!# maven-filesystem
rm -f %buildroot%_datadir/%{name}/repository-jni/JPP!."\n");

};


__END__
    $spec->get_section('posttrans','')->exclude_body(qr'^ln -sf `rpm .*/repository-jni/JPP');
    # maven-filesystem obsoletes 'ugly as hell' hack
    $spec->get_section('preun','')->multi_exclude_body(
qr'^\s*if',
qr'^\s*if\s.*/repository-jni/JPP',
qr'^\s*rm\s.*/repository-jni/JPP',
qr'^\s*fi',
qr'^\s*fi',
);
    # we are not ready for it yet - todo enable with a-c-p upgrade
#    $spec->get_section('package','')->exclude_body(qr'^Requires:\s+apache-commons-parent\s*$');

