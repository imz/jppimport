#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->source_apply_patch(PATCHFILE=>'jfreechart-component-info.xml-alt-jcommon16.patch',SOURCEFILE=>'jfreechart-component-info.xml');
};

__END__
