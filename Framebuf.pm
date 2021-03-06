package FlowFree::Framebuf;

# instances of this class are frame-buffers...  a grid that can be drawn on, and sent to the
# terminal

# monospace fonts that have enough unicode coverage for this (on Ubuntu):
#       - Liberation Mono
#       - Monospace
#       - Andale Mono
#       - Deja Vu Sans Mono
#       - Courier New
#       - FreeMono

    use strict;
    use warnings;

    use Data::Dumper;

use constant box_chars => [
    [qw[    ╹ ┗ ┃ ┛         ]],     # up
    [qw[    ┗ ╺ ┏ ━         ]],     # right
    [qw[    ┃ ┏ ╻ ┓         ]],     # down
    [qw[    ┛ ━ ┓ ╸         ]]  ];  # left


#use constant arrow_chars => [qw[ ↑ → ↓ ← ]];
use constant arrow_chars => [qw[ ⇑ ⇒  ⇓ ⇐ ]];

# map from bright colors => darker color pair 
#       (used to produce a checkerboard effect)
# color should be one of these:  http://www.mudpedia.org/wiki/Xterm_256_colors
use constant dark_colors => {
    237 => 235,       # black / dark gray
    9 => 88,        # red
    10 => 34,       # green
    11 => 3,
    12 => 4,
    13 => 5,
    14 => 6,
    15 => 7,
    231 => 249,     # FlowFree::Rasterized::occupied_mask
};

# Map from bright colors => fg color.
# Usually we use white for the foreground...  if we need to use something else, specify it here.
use constant fg_colors => {
    #10 => 0,        # green
    11 => 0,        # yellow
    231 => 0,
};

#use constant start_stop => "o";
#use constant start_stop => "•";
use constant start_stop => "ꔷ";
#use constant start_stop => "⚫";
#use constant start_stop => "·";
#use constant start_stop => "▚";


#use constant circle_diacritic => " ⃝";
use constant circle_diacritic => "";
#use constant circle_diacritic => "̳";

sub new { bless {}, shift }

sub resize {
    my ($self, $width, $height) = @_;
    $self->{width} = $width;
    $self->{height} = $height;
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
            $self->{gridcolor}[$x][$y] = 237;
        }
    }
}


sub clear {
    my ($self) = @_;
    $self->resize($self->{width}, $self->{height});
}


# color should be one of these:  http://www.mudpedia.org/wiki/Xterm_256_colors
sub draw_path {
    my ($self, $color_hi, $start_coord, $direction_list) = @_;
    
    my $x = $start_coord->[0];
    my $y = $start_coord->[1];
    
    my $errant_move = undef;

    ## draw start-segment
    $self->{gridcolor}[$x][$y] = $color_hi;
    # if the list is a single 'undef' value, then just draw a dot
    if (@$direction_list == 1 && !defined($direction_list->[0])) {
        $self->{grid}[$x][$y] = start_stop;
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
        if (!$self->is_blank_square($x, $y)) {
            $errant_move = $ctr;
            last;
        }
        $self->{grid}[$x][$y] = box_chars->[::flip($dir)][$next_dir];
        $self->{gridcolor}[$x][$y] = $color_hi;
        #print "($x,$y)  $dir→$next_dir\n";
    }

    ## draw finish-segment
    if (!defined($errant_move)) {
        $dir = $direction_list->[-1];
        $x += $::dir_delta[$dir][0];
        $y += $::dir_delta[$dir][1];
        if ($self->is_blank_square($x, $y)) {
            $dir = ::flip($dir);
            $self->{grid}[$x][$y] = box_chars->[$dir][$dir] . circle_diacritic;
            $self->{gridcolor}[$x][$y] = $color_hi;
        } else {
            $errant_move = scalar(@$direction_list) - 1;
        }
    }

    ## if we ever left the board, draw an arrow indicating the direction we were headed
    if (defined($errant_move)) {
        $x = $start_coord->[0];
        $y = $start_coord->[1];
        for (my $ctr=0; $ctr<$errant_move; $ctr++) {
            $dir = $direction_list->[$ctr];
            $x += $::dir_delta[$dir][0];
            $y += $::dir_delta[$dir][1];
        }
        $dir = $direction_list->[$errant_move];
        $self->{grid}[$x][$y] = arrow_chars->[$dir];
    }
}


sub draw_character {
    my ($self, $color_hi, $start_coord, $character) = @_;

    my $x = $start_coord->[0];
    my $y = $start_coord->[1];

    $self->{grid}[$x][$y] = $character;
    $self->{gridcolor}[$x][$y] = $color_hi;

    return;
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
                my $bg_brt_color = $self->{gridcolor}[$x][$y];
                my $bg_drk_color = dark_colors->{$bg_brt_color};
                $bg_drk_color = $bg_brt_color       if (!defined($bg_drk_color));
                my $bg_color = ($x+$y)%2 ? $bg_brt_color : $bg_drk_color;

                my $fg_color = fg_colors->{$bg_brt_color};
                $fg_color = 15      if (!defined($fg_color));

                $cell = "\e[48;5;${bg_color}m$cell\e[0m";
                $cell = "\e[38;5;${fg_color}m$cell\e[0m";
            }
            $string .= $cell;
        }
        $string .= "\n";
    }
    return $string;
}


# given a point, determine if it's inside the board
sub is_inside {
    my ($self, $x, $y) = @_;

       $x >= 0
    && $y >= 0
    && $x < $self->{width}
    && $y < $self->{height}
}


# given a point, determine if it's on a blank square  (AND that it's inside the board)
sub is_blank_square {
    my ($self, $x, $y, $color) = @_;

    $self->is_inside($x, $y)
        && ((defined($color) && $self->{gridcolor}[$x][$y] == $color)
            || $self->{grid}[$x][$y] eq ' '
            || $self->{grid}[$x][$y] eq start_stop);
}


1;
