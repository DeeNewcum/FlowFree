#!/usr/bin/perl

# A brute-force solver for FlowFree-style game boards.

# This runs in text mode, and it expects your terminal emulator to be able to:
#       - display Unicode characters
#       - handle 256 colors


    use strict;
    use warnings;

    BEGIN { chdir ".." }

    require "./mainspace.pm";
    require "./Framebuf.pm";
    require "./InitialBoard.pm";
    require "./Rasterized.pm";

    use Const::Fast;

    use Data::Dumper;
    #use Devel::Comments;           # uncomment this during development to enable the ### debugging statements



# level 1, "Bonus Pack"
my $board = new FlowFree::InitialBoard(
    height => 5,
    width  => 5,
    pairs => [
        [10,    0, 3,       4, 3],          # "B" / green
        [12,    1, 1,       3, 1],          # "C" / blue
        [11,    1, 3,       4, 1],          # "D" / yellow
        [9,     3, 3,       4, 4],          # "A" / red
    ],
);
my $display = new FlowFree::Framebuf;                                                                 

print $board->draw($display)->to_string(), "\n";


my $rasterized = FlowFree::Rasterized->new($board);
print $rasterized->draw($display)->to_string();


#print Dumper $display;


