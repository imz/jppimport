#!/usr/bin/perl -w

require 'add_missingok_config.pl';

# TODO: https://docs.gradle.org/current/userguide/command_line_interface.html
# --max-workers=2 --no-parallel
push @SPECHOOKS, 
sub {
    my ($spec, $parent) = @_;
    &add_missingok_config($spec, '/etc/java/%name.conf','');
    $spec->get_section('package','')->subst_body(qr'^BuildRequires:\s+js-jquery','#BuildRequires:  js-jquery');

    $spec->get_section('prep')->push_body(q!# alt linux
sed -i -e 's,/usr/share/fonts/lato,/usr/share/fonts/ttf/lato,;s,/usr/share/fonts/liberation,/usr/share/fonts/ttf/liberation,' ../../SOURCES/gradle-font-metadata.xml!."\n");
    $spec->get_section('build')->subst_body(qr'\%\{\?fedora:Fedora \}\%\{\?rhel:Red Hat \}','ALTLinux ');
    $spec->get_section('install')->push_body(q!sed -i -e s,/usr/bin/bash,/bin/sh, %buildroot%_bindir/*!."\n");

};

__END__
