#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;

    $jpp->get_section('install')->push_body(q!# jpp compat symlink
ln -s ant/ant-contrib.jar %buildroot%_javadir/ant-contrib.jar!."\n");
    $jpp->get_section('files')->push_body(q!%_javadir/ant-contrib.jar!."\n");
};

__END__
