#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($spec, $parent) = @_;
    $spec->source_apply_patch(
	    PATCHFILE => 'rxtx-2.2-lock.patch.diff',
	    SOURCEFILE=> 'rxtx-2.2-lock.patch');
};

__END__
