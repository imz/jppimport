#!/usr/bin/perl -w

require 'set_target_14.pl';

# other way is
push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('build')->subst(qr'^ant ', 'ant src.compile test.report src.javadoc deploy.zipfile ');
}
__END__
clean:
prepare:
src.compile:
test.instrument:
test.run:
test.report:
# FAILS with Out of memory (threads)
test.compatibility:

"clean"
"prepare" depends="clean"
"src.compile" depends="prepare"
"src.javadoc"
"test.instrument" depends="src.compile"
"test.run" depends="test.instrument"
"test.report" depends="test.run" 
"test.compatibility" depends="test.report"
"test.coverage" depends="test.compatibility" 
"jar.sqlmaps" depends="src.compile"
"jar.dao" depends="src.compile"
"jar.common" depends="src.compile"
"jar.compatibility" depends="src.compile"
"jar.src" depends="src.compile"
"jar.javadoc" depends="src.compile"
"deploy.assemble" depends="jar.sqlmaps,jar.dao,jar.common,jar.compatibility,jar.src, jar.javadoc"
"deploy.zipfile" depends="deploy.assemble"
"all" depends="test.coverage, src.javadoc, deploy.zipfile"
"convert"



#    $jpp->get_section('build')->unshift_body('export ANT_OPTS=" -Xmx80m "'."\n");
# does not help either
#    $jpp->get_section('build')->unshift_body('export ANT_OPTS=" -server -Xmx96m -Xss32m "'."\n");

...
I think a very naive formula is max threads = (2G - mx) / stacksize.
You may try to work with a smaller heap size or smaller stack sizes.
