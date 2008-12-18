#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
};

1;
__END__
# for jpp 1.7; now we import from fedora
    $jpp->get_section('package','')->unshift_body('BuildRequires: javacc rhino'."\n");
    $jpp->get_section('prep')->push_body(q!
# until 2.3.10 (bug reported upstream)
find ./src/freemarker/ext/ -type f -exec \
%__subst 's,.__class__.__name__,.__findattr__("__class__").__findattr__("__name__"),' \
 {} \;
!);
