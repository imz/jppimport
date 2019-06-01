#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($spec,) = @_;
    $spec->source_apply_patch(
	    PATCHFILE => 'rxtx-2.2-lock.patch.diff',
	    SOURCEFILE=> 'rxtx-2.2-lock.patch');
    $spec->source_apply_patch(
	    PATCHFILE => 'rxtx-sys_io_h_check.patch.diff',
	    SOURCEFILE=> 'rxtx-sys_io_h_check.patch');
    #$spec->get_section('build')->unshift_body_before(qr'configure','autoreconf -fisv'."\n");

};


__END__
