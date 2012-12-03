#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->source_apply_patch(
	    PATCHFILE => 'rxtx-2.2-lock.patch.diff',
	    SOURCEFILE=> 'rxtx-2.2-lock.patch');
};

__END__
