#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    # fc proxool
#sed -i 's,target="1.6" source="1.6",target="1.5" source="1.5",' proxool-no-embedded-cglib.patch
};

__END__
