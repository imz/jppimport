#!/usr/bin/perl -w

require 'set_velocity14.pl';

push @SPECHOOKS, 

sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('BuildRequires: excalibur-avalon-framework mojo-maven2-plugin-changes  mojo-maven2-plugin-jxr maven2-default-skin checkstyle-optional'."\n");
    $jpp->get_section('package','')->unshift_body('%define _without_tests 1'."\n");

    ######### included in set_velocity14 ##################
q{
    # hmm... is it will be runtime compatible? test...
    $jpp->get_section('package','')->unshift_body('BuildRequires(pre): velocity14'."\n");
    $jpp->get_section('build')->unshift_body(q!
# hack used to build ehcache w/velocity 1.4
mkdir -p .m2/repository/velocity/velocity/1.4
ln -s /usr/share/java/velocity-1.4.jar .m2/repository/velocity/velocity/1.4/
!);
};

    # removed when w/ hibernate3 was built
    # if w/o hibernate3
    # {
    #$jpp->get_section('package','')->unshift_body('%define _without_hibernate 1'."\n");
    #$jpp->get_section('build')->unshift_body_after('ln -sf $(build-classpath checkstyle) .'."\n", qr'^pushd tools');
    # test fails :(
    #$jpp->get_section('build')->subst(qr'build dist','dist-jar javadoc');
    # }
}

__END__
