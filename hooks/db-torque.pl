#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    # 5.0 bug
    $jpp->get_section('install')->subst('ln -s \%{name}-runtime-.jar ','ln -s %{name}-runtime-%{version}.jar ');

}
__END__
427c427
< ln -s %{name}-runtime-.jar $RPM_BUILD_ROOT%{_javadir}/%{name}.jar
---
> ln -s %{name}-runtime-%{version}.jar $RPM_BUILD_ROOT%{_javadir}/%{name}.jar
