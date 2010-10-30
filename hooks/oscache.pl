
push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('build')->unshift_body(q!
    export CLASSPATH=$(build-classpath ivy ant/ant-junit junit ant/ant-trax)
!);
};
