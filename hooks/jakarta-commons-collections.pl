#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    # due to missing @VERSION@, @TAG@
    $jpp->copy_to_sources('jakarta-commons-collections-component-info.xml');
    $jpp->get_section('install')->subst_if(qr'%{namedversion}','%{version}',qr'-brew');
};

__END__
