#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($spec,) = @_;
    $spec->source_apply_patch(PATCHFILE=>'sbt-sbt.patch',SOURCEFILE=>'sbt');
};

__END__
