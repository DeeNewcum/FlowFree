#!/usr/bin/perl

# <short description of program>

    use strict;
    use warnings;

    use Const::Fast;

    use Data::Dumper;
    #use Devel::Comments;           # uncomment this during development to enable the ### debugging statements


const my $UP    => 0;
const my $RIGHT => 1;
const my $DOWN  => 2;
const my $LEFT  => 3;

const my @dir_delta => (  [0,-1], [1,0], [0,1], [-1,0]  );

# change left <-> right, and up <-> down
sub flip {($_[0]+2)%4}


my $display = new FlowFree::Display;
$display->resize(3,3);
$display->draw_path(1,   0, 0,   [1, 2, 3]);
$display->draw_path(2,   2, 0,   [2, 2, 3, 3]);
print $display->to_string();

#print Dumper $display;




package FlowFree::Display;

    use strict;
    use warnings;

    use Data::Dumper;

use constant box_chars => [
    [qw[    ╹ ┗ ┃ ┛         ]],     # up
    [qw[    ┗ ╺ ┏ ━         ]],     # right
    [qw[    ┃ ┏ ╻ ┓         ]],     # down
    [qw[    ┛ ━ ┓ ╸         ]]  ];  # left

#use constant circle_diacritic => " ⃝";
use constant circle_diacritic => "";
#use constant circle_diacritic => "̳";

sub new { bless {}, shift }

sub resize {
    my ($self, $width, $height) = @_;
    $self->{grid} = [
            map {
                    [ map { ' ' } 1..$height ]
            } 1..$width
        ];
    $self->{gridcolor} = [
            map {
                    [ map { '' } 1..$height ]
            } 1..$width
        ];

    foreach my $y (0..($height-1)) {
        foreach my $x (0..($width-1)) {
            $self->{gridcolor}[$x][$y] = 8      if (($x+$y)%2);
        }
    }
}


# color should be one of these:  http://www.mudpedia.org/wiki/Xterm_256_colors
sub draw_path {
    my ($self, $color, $start_x, $start_y, $direction_list) = @_;
    
    my $x = $start_x;
    my $y = $start_y;

    ## draw start-segment
    my $dir = $direction_list->[0];
    $self->{grid}[$x][$y] = box_chars->[$dir][$dir] . circle_diacritic;
    $self->{gridcolor}[$x][$y] = $color;
    #print "($x,$y)  $dir→$dir\n";

    ## draw intermediate segments
    for (my $ctr=0; $ctr<@$direction_list-1; $ctr++) {
        $dir = $direction_list->[$ctr];
        my $next_dir = $direction_list->[$ctr+1];
        $x += $dir_delta[$dir][0];
        $y += $dir_delta[$dir][1];
        $self->{grid}[$x][$y] = box_chars->[::flip($dir)][$next_dir];
        $self->{gridcolor}[$x][$y] = $color;
        #print "($x,$y)  $dir→$next_dir\n";
    }

    ## draw finish-segment
    $dir = $direction_list->[-1];
    $x += $dir_delta[$dir][0];
    $y += $dir_delta[$dir][1];
    $dir = ::flip($dir);
    $self->{grid}[$x][$y] = box_chars->[$dir][$dir] . circle_diacritic;
    $self->{gridcolor}[$x][$y] = $color;
}


sub to_string {
    my ($self) = @_;

    my $string = '';
    my $height = scalar @{$self->{grid}[0]};
    my $width  = scalar @{$self->{grid}};
    foreach my $y (0..($height-1)) {
        foreach my $x (0..($width-1)) {
            my $cell = $self->{grid}[$x][$y];
            if (length($self->{gridcolor}[$x][$y] || '')) {
                $cell = "\e[48;5;$self->{gridcolor}[$x][$y]m$cell\e[0m";
                #$cell = "\e[38;5;$self->{gridcolor}[$x][$y]m$cell\e[0m";
            }
            $string .= $cell;
        }
        $string .= "\n";
    }
    return $string;
}
