package FlowFree::Framebuf;

# instances of this class are frame-buffers...  a grid that can be drawn on, and sent to the
# terminal

    use strict;
    use warnings;

    use Data::Dumper;

use constant box_chars => [
    [qw[    ╹ ┗ ┃ ┛         ]],     # up
    [qw[    ┗ ╺ ┏ ━         ]],     # right
    [qw[    ┃ ┏ ╻ ┓         ]],     # down
    [qw[    ┛ ━ ┓ ╸         ]]  ];  # left

# map from bright colors => darker color pair 
#       (used to produce a checkerboard effect)
use constant dark_colors => {
    8 => 0,
    9 => 1,
    10 => 2,
    11 => 3,
    12 => 4,
    13 => 5,
    14 => 6,
    15 => 7,
};

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
    my ($self, $color_hi, $start_coord, $direction_list) = @_;
    
    my $x = $start_coord->[0];
    my $y = $start_coord->[1];

    my $color_lo = dark_colors->{$color_hi};
    $color_lo = $color_hi   if (!defined($color_lo));

    ## draw start-segment
    $self->{gridcolor}[$x][$y] = ($x+$y)%2 ? $color_hi : $color_lo;
    # if the list is a single 'undef' value, then just draw a dot
    if (@$direction_list == 1 && !defined($direction_list->[0])) {
        $self->{grid}[$x][$y] = "O";
        return;
    }
    my $dir = $direction_list->[0];
    $self->{grid}[$x][$y] = box_chars->[$dir][$dir] . circle_diacritic;
    #print "($x,$y)  $dir→$dir\n";

    ## draw intermediate segments
    for (my $ctr=0; $ctr<@$direction_list-1; $ctr++) {
        $dir = $direction_list->[$ctr];
        my $next_dir = $direction_list->[$ctr+1];
        $x += $::dir_delta[$dir][0];
        $y += $::dir_delta[$dir][1];
        $self->{grid}[$x][$y] = box_chars->[::flip($dir)][$next_dir];
        $self->{gridcolor}[$x][$y] = ($x+$y)%2 ? $color_hi : $color_lo;
        #print "($x,$y)  $dir→$next_dir\n";
    }

    ## draw finish-segment
    $dir = $direction_list->[-1];
    $x += $::dir_delta[$dir][0];
    $y += $::dir_delta[$dir][1];
    $dir = ::flip($dir);
    $self->{grid}[$x][$y] = box_chars->[$dir][$dir] . circle_diacritic;
    $self->{gridcolor}[$x][$y] = ($x+$y)%2 ? $color_hi : $color_lo;
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

1;
