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
    require "./PathSet.pm";
    require "./Rasterized.pm";

    use Carp::Always;

    use Data::Dumper;
    #use Devel::Comments;           # uncomment this during development to enable the ### debugging statements



my $board = new FlowFree::InitialBoard(
    height => 4,
    width  => 4,
    pairs => [
        [9,     0, 0,           0, 1],
        [10,    2, 0,           0, 2],
        [12,    3, 0,           0, 3],
    ],
);


my $pathset = FlowFree::PathSet->new($board);
$pathset->{paths} = [
        [1, 2, 3],
        [2, 2, 3, 3],
    ];
$pathset->{current_depth} = 2;


my $rasterized = FlowFree::Rasterized->new($pathset);


my $framebuf = new FlowFree::Framebuf;                                                                 
print $board->draw($framebuf)->to_string(), "\n";
print $pathset->draw($framebuf)->to_string(), "\n";
print $rasterized->draw($framebuf)->to_string(), "\n";
