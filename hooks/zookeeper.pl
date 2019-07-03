require 'set_libexec.pl';

push @SPECHOOKS,
sub {
    my ($spec,) = @_;
    $spec->source_apply_patch(SOURCEFILE=>'zookeeper.service', PATCHFILE=>'zookeeper.service.diff');
};

__END__
