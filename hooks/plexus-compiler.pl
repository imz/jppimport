#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    # till new eclipse?
    $jpp->get_section('package','')->unshift_body('BuildRequires: ecj3'."\n");
    $jpp->get_section('install')->push_body(q!# compat pom
%add_to_maven_depmap plexus plexus-compiler-api %{version} JPP/plexus compiler-api
!."\n");
};

__END__
