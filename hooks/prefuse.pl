#!/usr/bin/perl -w

push @SPECHOOKS, sub {};

1;

__END__
# we have run at front of the engine
# TODO: write patch for new lucene!
rm ./src/prefuse/data/search/LuceneSearcher.java
rm ./src/prefuse/data/search/KeywordSearchTupleSet.java
