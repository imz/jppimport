#!/usr/bin/perl -w

require 'set_epoch_1.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->del_section('pre','');
    $jpp->del_section('triggerpostun','','commons-collections < 3.0');
};

__END__
# this pre is buggy (5.0; erases commons-collections-tomcat5 as well) TO REPORT
%pre
rm -f %{_javadir}/%{short_name}*.jar
rm -f %{_javadir}/%{name}*.jar

%triggerpostun -- commons-collections < 3.0
pushd %{_javadir} &> /dev/null
    ln -sf %{name}-%{version}.jar %{short_name}-%{version}.jar
    ln -sf %{short_name}-%{version}.jar %{short_name}.jar
popd &> /dev/null
