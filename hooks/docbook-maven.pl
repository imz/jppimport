push @SPECHOOKS, 
 sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','-n docbook-xsl-xalan')->push_body('Provides: docbook-xsl-java-xalan = 1.67'."\n");
    $jpp->get_section('files','-n fo-editor')->push_body(q{#unpackaged directory: 
%dir %_datadir/fo-editor/configuration
%dir %_datadir/fo-editor/templates
});
};

__END__
