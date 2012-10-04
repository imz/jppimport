#!/usr/bin/perl -w

#require 'set_target_14.pl';
require 'set_fix_repolib_project.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->push_body('Provides: junit = 0:%{version}'."\n");
    $jpp->get_section('package','')->push_body('Provides: junit3 = %{epoch}:%{version}-%{release}'."\n");
    $jpp->get_section('install')->push_body(q!# symlink
ln -s %{name}.jar $RPM_BUILD_ROOT%{_javadir}/%{name}3.jar!."\n");
    $jpp->get_section('files','')->push_body(q!%{_javadir}/%{name}3.jar!."\n");
};

__END__
