#!/usr/bin/perl -w

push @SPECHOOKS,
sub {
    my ($spec,) = @_;
    $spec->add_patch('jffi-1.2.12-aarch64.patch',STRIP=>1);
};

__END__
