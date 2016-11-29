
push @SPECHOOKS, 
sub {
    my ($spec, $parent) = @_;
#    $spec->get_section('build')->unshift_body(q!
#    export CLASSPATH=$(build-classpath ivy ant/ant-junit junit ant/ant-trax)
#!);
};
