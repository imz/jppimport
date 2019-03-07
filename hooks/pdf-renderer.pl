push @SPECHOOKS, 
sub {
    my ($spec,) = @_;
    $spec->get_section('install')->push_body('
# compat symlink (requected by @REAL); just let it be (but use pdf-renderer.jar, please!)
pushd %buildroot%_javadir
ln -s pdf-renderer.jar PDFRenderer.jar
');
    $spec->get_section('files')->push_body('%_javadir/PDFRenderer.jar'."\n");
};
