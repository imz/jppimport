#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($spec, $parent) = @_;
    # this is fc issue, not an upstream issue
    $spec->add_patch('native-platform-0.10-as-needed.patch',STRIP=>1);
    $spec->get_section('build')->exclude_body(qr'^LDFLAGS="\$\{LDFLAGS:-\%__global_ldflags\}";');
};

__END__
