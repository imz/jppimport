#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    #$jpp->add_patch('',STRIP=>1);
    $jpp->get_section('install')->subst_body(qr'%add_maven_depmap\s+JPP.\%{name}-','%add_maven_depmap -a "%{name}:%{name}" JPP.%{name}-');
    # jpp compat symlink
    $jpp->get_section('install')->push_body(q!ln -s %{name}/%{name}.jar %buildroot%{_javadir}/%{name}.jar!."\n");
    $jpp->get_section('files')->push_body(q!%{_javadir}/%{name}.jar!."\n");
};

__END__
