#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($spec, $parent) = @_;
    $spec->source_apply_patch(PATCHFILE=>'Mars-4.5-alt-george-fix-bug-33076.patch',SOURCEFILE=>'build.xml');
    $spec->get_section('install')->subst_body(qr'--add-category="Development"','--add-category="Development" --add-category="IDE"');
};

__END__
