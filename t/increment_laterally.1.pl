#!/usr/bin/perl


    use strict;
    use warnings;

        # improved version of FindBin
        use Cwd 'abs_path';
        use File::Basename;
        use lib dirname( dirname( abs_path $0 ) );

    require "mainspace.pm";
    require "Framebuf.pm";
    require "InitialBoard.pm";
    require "PathSet.pm";

    use Carp;
    use Const::Fast;

    use Data::Dumper;
    #use Devel::Comments;           # uncomment this during development to enable the ### debugging statements


$SIG{INT} = sub {
    Carp::carp "caught a Ctrl-C";
};


# level 1, "Bonus Pack"
my $board = new FlowFree::InitialBoard(
    height => 3,
    width  => 3,
    pairs => [
        [9,     0, 1,       0, 2],
        [11,    0, 0,       2, 1],
    ],
);
my $framebuf = new FlowFree::Framebuf;                                                                 

print $board->draw($framebuf)->to_string(), "\n";


my $pathset = new FlowFree::PathSet($board);
$pathset->{paths} = [
        [1, 2, 0],
        [1, 1, 0],
    ];
$pathset->{current_depth} = 2;

print $pathset->draw($framebuf)->to_string();


while ($pathset->increment_laterally()) {
    print $pathset->draw($framebuf)->to_string();
}


#print Dumper $framebuf;


