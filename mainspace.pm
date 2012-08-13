#!/usr/bin/perl

    use strict;
    use warnings;

    use Const::Fast;

    use Data::Dumper;
    #use Devel::Comments;           # uncomment this during development to enable the ### debugging statements


const my $UP    => 0;       # Conventions we use for directions.
const my $RIGHT => 1;       # Often, we just use the numbers.
const my $DOWN  => 2;
const my $LEFT  => 3;

const our @dir_delta => (  [0,-1], [1,0], [0,1], [-1,0]  );

# change left <-> right, and up <-> down
sub flip {($_[0]+2)%4}

1;
