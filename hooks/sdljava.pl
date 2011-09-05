#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->add_patch('sdljava-0.9.1-alt-ruby19.patch',STRIP=>1);
    my $src=$jpp->add_source('post-process.rb');
    $jpp->get_section('package','')->unshift_body('BuildRequires: ruby-stdlibs zlib-devel'."\n");
    $jpp->get_section('prep')->push_body(q!cp %{S:!.$src.q!} src/org/gljava/opengl/native/ftgl/post-process.rb!."\n");
    $jpp->get_section('install')->subst(qr'/fonts/dejavu/','/fonts/ttf/dejavu/');
    $jpp->get_section('package','demo')->subst(qr'/fonts/dejavu/','/fonts/ttf/dejavu/');
};

__END__
