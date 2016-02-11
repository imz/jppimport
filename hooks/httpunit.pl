#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($spec, $parent) = @_;
    $spec->get_section('prep')->subst_body(qr'^mv \%\{SOURCE','install -m 644 %{SOURCE');
    $spec->get_section('files','doc')->subst(qr'\%doc ','%doc --no-dereference ');
};

__END__
