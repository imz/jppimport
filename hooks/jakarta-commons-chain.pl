#!/usr/bin/perl -w

# due to out of memory errors
push @SPECHOOKS, 
 sub {
    my ($jpp, $alt) = @_;
    # todo: report?
    $jpp->get_section('build')->subst(qr!jar javadoc xdoc:transform!,'xdoc:transform');
    $jpp->get_section('build')->unshift_body_before(q!
maven -e \
        -Dmaven.javadoc.source=1.4 \
        -Dmaven.repo.remote=file:/usr/share/maven/repository \
        -Dmaven.home.local=$(pwd)/.maven \
        jar javadoc

!, qr'^maven');
}
