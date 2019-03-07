#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($spec,) = @_;
    $spec->add_patch('apache-parent-no-enforcer-loop.patch',STRIP=>1);
};

__END__
