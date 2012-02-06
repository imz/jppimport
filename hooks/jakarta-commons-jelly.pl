#!/usr/bin/perl -w

push @SPECHOOKS, 
sub  {
    my ($jpp, $alt) = @_;
    $jpp->add_patch('commons-jelly-1.0-alt-velocity-fix-incorrect-logsystem.patch',STRIP=>0);
};
__END__

    $jpp->get_section('package','')->unshift_body('BuildRequires: jline'."\n");
    my $srcnum=$jpp->add_source('ant-SNAPSHOT-20071102.tar');
    $jpp->get_section('prep')->push_body(
'pushd jelly-tags
rm -rf ant
tar xf %{SOURCE'.$srcnum.'}
popd
');
    $jpp->add_patch('commons-jelly-1.0-alt-xml-unit-1.2-support.patch',STRIP=>1);




################### old jpp5 ###############################################3

#added commons-collections to classpath:
%s,build-classpath commons-beanutils commons-jexl commons-logging dom4j jaxen,build-classpath commons-beanutils commons-jexl commons-logging dom4j jaxen commons-collections,c
%s,build-classpath commons-beanutils commons-betwixt commons-digester commons-jexl commons-logging dom4j jaxen,build-classpath commons-beanutils commons-betwixt commons-digester commons-jexl commons-logging dom4j jaxen commons-collections,c
%s,build-classpath commons-beanutils commons-logging mx4j/mx4j-jmx dom4j jaxen,build-classpath commons-beanutils commons-logging mx4j/mx4j-jmx dom4j jaxen commons-collections,c
[...]
#----
616c616
<     CLASSPATH=$CLASSPATH:$(build-classpath commons-beanutils commons-jexl commons-logging dom4j jaxen)
---
>     CLASSPATH=$CLASSPATH:$(build-classpath commons-beanutils commons-jexl commons-logging dom4j jaxen commons-collections)
636c636
<     CLASSPATH=$CLASSPATH:$(build-classpath commons-beanutils commons-jexl commons-logging dom4j jaxen)
---
>     CLASSPATH=$CLASSPATH:$(build-classpath commons-beanutils commons-jexl commons-logging dom4j jaxen commons-collections)
651c651
<     CLASSPATH=$CLASSPATH:$(build-classpath commons-beanutils commons-betwixt commons-digester commons-jexl commons-logging dom4j jaxen)
---
>     CLASSPATH=$CLASSPATH:$(build-classpath commons-beanutils commons-betwixt commons-digester commons-jexl commons-logging dom4j jaxen commons-collections)
664c664
<     CLASSPATH=$CLASSPATH:$(build-classpath commons-beanutils commons-jexl commons-logging dom4j jaxen)
---
>     CLASSPATH=$CLASSPATH:$(build-classpath commons-beanutils commons-jexl commons-logging dom4j jaxen commons-collections)
674c674
<     CLASSPATH=$CLASSPATH:$(build-classpath commons-beanutils commons-jexl commons-logging dom4j jaxen)
---
>     CLASSPATH=$CLASSPATH:$(build-classpath commons-beanutils commons-jexl commons-logging dom4j jaxen commons-collections)
739c739
<     CLASSPATH=$CLASSPATH:$(build-classpath commons-beanutils commons-logging mx4j/mx4j-jmx dom4j jaxen)
---
>     CLASSPATH=$CLASSPATH:$(build-classpath commons-beanutils commons-logging mx4j/mx4j-jmx dom4j jaxen commons-collections)
770c770
<     CLASSPATH=$CLASSPATH:$(build-classpath commons-beanutils commons-jexl commons-lang commons-logging dom4j jaxen)
---
>     CLASSPATH=$CLASSPATH:$(build-classpath commons-beanutils commons-jexl commons-lang commons-logging dom4j jaxen commons-collections)
798c798
<     CLASSPATH=$CLASSPATH:$(build-classpath commons-beanutils commons-collections commons-jexl commons-logging xmlunit dom4j jaxen)
---
>     CLASSPATH=$CLASSPATH:$(build-classpath commons-beanutils commons-collections commons-jexl commons-logging xmlunit dom4j jaxen commons-collections)
