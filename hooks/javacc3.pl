#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
#   no need for that
#    $jpp->get_section('install')->unshift_body2_after('%add_to_maven_depmap net.java.dev.javacc javacc %{version} JPP %{name}
#',qr'%add_to_maven_depmap');
};

__END__
