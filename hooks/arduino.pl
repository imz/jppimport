#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($spec,) = @_;
    $spec->source_apply_patch(SOURCEFILE=>'arduino-1.8.3-use-system-avrdude.patch',PATCHFILE=>'arduino-1.8.3-use-system-avrdude.patch.diff');
    $spec->add_patch('arduino-1.8.5-use-system-listSerialsj.patch',STRIP=>1);
    $spec->get_section('install')->push_body(q!# unFedorize; ALTize
if grep 'dialout lock' %buildroot/%_bindir/arduino; then
   sed -i -e 's,dialout lock,uucp,' %buildroot/%_bindir/arduino
else
   echo "ALT-specific group hack is deprecated"
   exit 2
fi
!."\n");
};

__END__
