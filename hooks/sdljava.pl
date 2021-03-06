#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($spec,) = @_;
    $spec->get_section('package','')->unshift_body('BuildRequires: bsh'."\n");
    $spec->get_section('package','')->unshift_body('BuildRequires: ruby-stdlibs zlib-devel'."\n");
};

__END__
    my $src=$spec->add_source('post-process.rb');
    $spec->get_section('prep')->push_body(q!cp %{S:!.$src.q!} src/org/gljava/opengl/native/ftgl/post-process.rb!."\n");

# in Generic.pm
    $spec->get_section('install')->subst_body(qr'/fonts/dejavu/','/fonts/ttf/dejavu/');
    $spec->get_section('package','demo')->subst_body(qr'/fonts/dejavu/','/fonts/ttf/dejavu/');
