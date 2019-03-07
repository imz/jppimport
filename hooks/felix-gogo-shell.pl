#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($spec,) = @_;
    $spec->get_section('package','javadoc')->subst_body(qr'\%\{pkg_name\}','%{name}');
    $spec->get_section('description','javadoc')->subst_body(qr'\%\{pkg_name\}','%{name}');
};

__END__
