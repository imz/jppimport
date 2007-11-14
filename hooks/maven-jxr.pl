#!/usr/bin/perl -w

$spechook = sub {
    my ($jpp, $alt) = @_;
#bug to report
#%post javadoc
#rm -f %{_javadocdir}/%{name}
#ln -s %{name}-%{namedversion} %{_javadocdir}/%{name}
    $jpp->get_section('post','javadoc')->subst('namedversion',"version");
}
