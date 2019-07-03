#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($spec,) = @_;
    $spec->main_section->unshift_body('%define _libexecdir %_prefix/libexec'."\n");
};

__END__
