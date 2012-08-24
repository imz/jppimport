#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
};

__END__
    # TODO
    $jpp->get_section('prep')->push_body(q!TODO:
Provides: mojo-maven2-plugin-rat = 18
Obsoletes: mojo-maven2-plugin-rat < 18
!."\n");

    $jpp->get_section('install')->push_body(q!
%add_
!."\n");
        <groupId>org.codehaus.mojo</groupId>
        <artifactId>rat-maven-plugin</artifactId>

        <groupId>JPP/apache-rat</groupId>
        <artifactId>apache-rat-plugin</artifactId>
        <version>0.8</version>
