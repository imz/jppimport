#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($spec,) = @_;
    $spec->source_apply_patch(
	    PATCHFILE => 'rxtx-2.2-lock.patch.diff',
	    SOURCEFILE=> 'rxtx-2.2-lock.patch');

    # from http://man7.org/linux/man-pages/man2/inl.2.html:
    # #include <sys/io.h> ... inl, inw, outb ...
    $spec->add_patch('rxtx-20100211-alt-hack.patch',STRIP=>1);

};


__END__
