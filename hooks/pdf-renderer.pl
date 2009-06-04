push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('install')->push_body('
# compat symlink (requected by @REAL); just let it be (but use pdf-renderer.jar, please!)
pushd %buildroot%_javadir
ln -s pdf-renderer.jar PDFRenderer.jar
');
    $jpp->get_section('files')->push_body('%_javadir/PDFRenderer.jar'."\n");
};
