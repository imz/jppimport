#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($spec,) = @_;
    $spec->spec_apply_patch('PATCHFILE'=>'grizzly.spec.diff');
};

__END__
