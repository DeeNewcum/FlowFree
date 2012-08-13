#!/usr/bin/perl


    use strict;
    use warnings;

    BEGIN { chdir ".." }

    require "./mainspace.pm";
    require "./Framebuf.pm";
    require "./InitialBoard.pm";

    use Const::Fast;

    use Data::Dumper;
    #use Devel::Comments;           # uncomment this during development to enable the ### debugging statements



# level 1, "Bonus Pack"
my $board = new FlowFree::InitialBoard(
    height => 3,
    width  => 3,
    pairs => [
        [9,     0, 0,       0, 1],
        [11,    0, 2,       2, 0],
    ],
);
my $display = new FlowFree::Framebuf;                                                                 

$board->draw($display);
print $display->to_string();

#print Dumper $display;


