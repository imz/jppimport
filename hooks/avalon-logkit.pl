#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;

    $jpp->get_section('install')->subst_body_if(qr',org.apache.avalon.logkit:\%{name}"',',org.apache.avalon.logkit:%{name},avalon:%{name}"',qr'add_maven_depmap');
};

__END__
