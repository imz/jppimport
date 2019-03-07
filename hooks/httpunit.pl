#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($spec,) = @_;
    $spec->get_section('prep')->subst_body(qr'^mv \%\{SOURCE','install -m 644 %{SOURCE');
    $spec->get_section('files','doc')->subst_body(qr'\%doc ','%doc --no-dereference ');
};

__END__
