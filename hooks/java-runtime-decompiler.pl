#!/usr/bin/perl -w
require 'set_no_fedora_vendor.pl';

push @SPECHOOKS,
sub {
    my ($spec,) = @_;
    $spec->get_section('prep')->push_body(q!sed -i 's,/usr/bin/bash,/bin/bash,;s,^run ,jvm_run ,' %{SOURCE1} %{SOURCE4}!."\n");
    $spec->get_section('build')->map_body(sub{s,#export\s+JAVA_HOME,export JAVA_HOME,});
};

__END__
