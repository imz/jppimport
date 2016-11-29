#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($spec, $parent) = @_;
    $spec->get_section('build')->subst_body(qr'mvn-rpmbuild ','mvn-rpmbuild -e -Dmaven.test.skip=true ');
};

__END__
