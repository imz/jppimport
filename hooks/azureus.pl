#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($spec,) = @_;
    #$spec->spec_apply_patch(PATCHFILE => 'azureus.spec.diff');

    $spec->main_section->push_body('# alt #39429
Requires: libjavascriptcoregtk3'."\n");
    $spec->main_section->push_body('Requires: java'."\n");
    $spec->main_section->push_body('# old azureus name
Conflicts: vuse < 4.2.0.3
Obsoletes: vuse < 4.2.0.3'."\n");

    $spec->get_section('install')->push_body(q!# alt adaptation
sed -i s,JAVA_HOME=/usr/lib/jvm/java-openjdk,JAVA_HOME=/usr/lib/jvm/java,g %buildroot%_bindir/%name
sed -i 's,uname -i,uname -m,' %buildroot%_bindir/%name
!);
};

__END__
