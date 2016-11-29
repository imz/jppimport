#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($spec, $parent) = @_;
    $spec->get_section('package','')->unshift_body('BuildRequires: ruby-stdlibs zlib-devel'."\n");
};

__END__
    my $src=$spec->add_source('post-process.rb');
    $spec->get_section('prep')->push_body(q!cp %{S:!.$src.q!} src/org/gljava/opengl/native/ftgl/post-process.rb!."\n");

# in Generic.pm
    $spec->get_section('install')->subst(qr'/fonts/dejavu/','/fonts/ttf/dejavu/');
    $spec->get_section('package','demo')->subst(qr'/fonts/dejavu/','/fonts/ttf/dejavu/');
# in upstream
#    $spec->add_patch('sdljava-0.9.1-alt-ruby19.patch',STRIP=>1);
