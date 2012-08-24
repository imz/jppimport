#!/usr/bin/perl -w

require 'add_missingok_config.pl';

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;

    # Следующие пакеты имеют неудовлетворенные зависимости:
    # maven: Требует: /etc/mavenrc но пакет не может быть установлен
    &add_missingok_config($jpp,'/etc/mavenrc');

    # alternatively
    # for /etc/mavenrc
    #%add_findreq_skiplist /usr/share/maven/bin/*

    # we are not ready for it yet - todo enable with a-c-p upgrade
    $jpp->get_section('package','')->exclude_body(qr'^Requires:\s+apache-commons-parent\s*$');

    $jpp->get_section('package','')->exclude_body(qr'^Requires:\s+yum-utils\s*$');
};

push @PREHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    # maven-filesystem
    $jpp->get_section('package','')->push_body(q!# maven-filesystem
Requires: maven-filesystem
BuildArch: noarch
!."\n");
    $jpp->get_section('install')->push_body(q!# maven-filesystem
rm -f %buildroot%_datadir/%{name}/repository-jni/JPP!."\n");

    # maven-filesystem obsoletes 'ugly as hell' hack
    $jpp->get_section('preun','')->multi_exclude_body(
qr'^\s*if',
qr'^\s*if\s.*/repository-jni/JPP',
qr'^\s*rm\s.*/repository-jni/JPP',
qr'^\s*fi',
qr'^\s*fi',
);
    $jpp->get_section('posttrans','')->exclude_body(qr'^ln -sf `rpm .*/repository-jni/JPP');
};


__END__
