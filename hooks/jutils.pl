#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('build')->subst_body(qr'mvn-rpmbuild ','mvn-rpmbuild -e -Dmaven.test.skip=true ');
};

__END__
