#!/usr/bin/perl

# A brute-force solver for FlowFree-style game boards.

# This runs in text mode, and it expects your terminal emulator to be able to:
#       - display Unicode characters
#       - handle 256 colors


    use strict;
    use warnings;

    require "./mainspace.pm";
    require "./Framebuf.pm";

    use Const::Fast;

    use Data::Dumper;
    #use Devel::Comments;           # uncomment this during development to enable the ### debugging statements



my $display = new FlowFree::Framebuf;
$display->resize(4,4);
$display->draw_path(9,   [0, 0],   [1, 2, 3]);
$display->draw_path(10,   [2, 0],   [2, 2, 3, 3]);
$display->draw_path(12,   [3, 0],   [undef]);
$display->draw_path(12,   [0, 3],   [undef]);
print $display->to_string();

#print Dumper $display;


