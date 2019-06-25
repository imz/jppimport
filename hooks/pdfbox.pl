#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($spec,) = @_;
    my $patch0=$spec->{SOURCEDIR}.'/pdfbox-use-system-liberation-font.patch';
    die "Oops! no patch $patch0" if ! -e $patch0;
    # already fixed by us
    return if system ('grep', '/usr/share/fonts/ttf', $patch0) == 0;
    die "Oops! strange patch $patch0" if system ('grep', '/usr/share/fonts/', $patch0);
    system ('sed','-i', 's,/usr/share/fonts,/usr/share/fonts/ttf,g',$patch0);
};

__END__
