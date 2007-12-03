push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('prep')->push_body(q!
pushd config
ln -s $(build-classpath objectweb-anttask) ow_util_ant_tasks.jar
popd
!);

}
