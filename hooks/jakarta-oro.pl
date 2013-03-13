#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->push_body('Provides: oro = %epoch:%version-%release'."\n");

    my $source1=$jpp->add_source(FILE=>'oro-2.0.8.pom', NAME=> 'http://mirrors.ibiblio.org/pub/mirrors/maven2/oro/oro/2.0.8/oro-2.0.8.pom');
    $jpp->get_section('install')->push_body('# pom
mkdir -p %{buildroot}%{_mavenpomdir}
cp -p %{SOURCE'.$source1.'} %{buildroot}%{_mavenpomdir}/JPP-%{name}.pom
%add_to_maven_depmap oro oro %{version} JPP %{name}'."\n");
    $jpp->get_section('files','')->push_body('%_mavendepmapfragdir/*
%_mavenpomdir/*.pom'."\n");
};

__END__
