#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('install')->push_body(q!# compat for jetty6
%add_to_maven_depmap_at %{name}-api org.apache.maven maven-plugin-tools-api %{version} JPP/%{name} api
!."\n");
};

__END__
