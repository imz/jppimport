#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->subst('velocity14','velocity');
};

__END__
#bug to report
#%post javadoc
#rm -f %{_javadocdir}/%{name}
#ln -s %{name}-%{namedversion} %{_javadocdir}/%{name}
    $jpp->get_section('post','javadoc')->subst('namedversion',"version");

