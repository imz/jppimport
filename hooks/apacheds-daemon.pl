#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body("BuildRequires: maven-surefire-plugin\n");
};

__END__
added: for maven 2.0.8
install -Dm644 %{SOURCE1} m2_repo/repository/org/apache/directory/build/1.0.5/build-1.0.5.pom
