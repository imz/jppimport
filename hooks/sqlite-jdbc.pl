#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($spec, $parent) = @_;
    $spec->add_patch('sqlite-jdbc-alt-linkage.patch',STRIP=>0);
};

__END__
