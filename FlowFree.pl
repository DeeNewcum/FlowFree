#!/usr/bin/perl

# A brute-force solver for FlowFree-style game boards.

# This runs in text mode, and it expects your terminal emulator to be able to:
#       - display Unicode characters
#       - handle 256 colors


    use strict;
    use warnings;

    require "./Display.pm";

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


my $display = new FlowFree::Display;
$display->resize(3,3);
$display->draw_path(9,   [0, 0],   [1, 2, 3]);
$display->draw_path(10,   [2, 0],   [2, 2, 3, 3]);
print $display->to_string();

#print Dumper $display;


