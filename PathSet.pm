package FlowFree::PathSet;

# Each instance of this class holds a "path set" -- a collection of paths, one
# path for each pair of dots.
#
# Each path is a series of moves (up, down, left, right) to make.  So a path might be "up, up,
# right, right, up, up".  Each path is associated with a particular starting point, and a particular
# color.
#
# The pathset is the main thing that we iterate over, when searching for an acceptable solution.
#
# When we start iterating, each path only has one move.  We add moves onto the end of each path, as
# iteration progresses.  As the board gets more filled, paths may end up becoming different lengths,
# because a path stops growing once 1) it reaches its destination, or 2) it has nowhere to turn.

    use strict;
    use warnings;

    use Storable qw[dclone];
    use Data::Dumper;

# you can either pass it an existing PathSet to clone it, or, pass it these parameters to create a
# brand new object:
#
#       - a reference to a FlowFree::InitialBoard object
#               (because we need to know the starting location of each path)
sub new {
    my $class = shift;

    if (ref($_[0]) eq 'FlowFree::PathSet') {
        my %clone = %{shift()};
        my $self = {
            paths => dclone( $clone{paths} ),
            board => $clone{board},
            current_depth => $clone{current_depth},
        };
        return bless $self, $class;
    } else {
        my $initial_board = shift;          # a FlowFree::InitialBoard object
        my $numpairs = scalar @{$initial_board->{pairs}};
        my $self = {
            board => $initial_board,
            paths => [ map { [0] }  0..($numpairs-1) ],
            current_depth => 0,
        };
        return bless $self, $class;
    }
}


sub draw {
    my ($self, $framebuf) = @_;

    #$framebuf->resize( $self->{board}{width}, $self->{board}{height} );
    $self->{board}->draw($framebuf);

    my @board_paths = @{ $self->{board}{pairs} };
    for my $pathnum (0 .. scalar(@board_paths)-1) {
        $framebuf->draw_path(
                $board_paths[$pathnum][0],       # color
                [  $board_paths[$pathnum][1],    # starting coordinates
                   $board_paths[$pathnum][2]  ],
                $self->{paths}[$pathnum],
            );
    }

    return $framebuf;
}


# "Laterally" is a direction in the game-tree:  the same direction as "width first".
#
# This twiddles different directions on the bottom layer of the tree.
#
# Returns:   false = we have tried all possible combinations for this layer
#            true = we still have some combinations to try
sub increment_laterally {
    my ($self) = shift;

    my $current_depth = $self->{current_depth};
    my $more_to_go = 0;
    for (my $ctr=0; $ctr<@{$self->{paths}}; $ctr++) {
        next unless (exists $self->{paths}[$ctr][$current_depth]);
        $self->{paths}[$ctr][$current_depth]++;
        if ($self->{paths}[$ctr][$current_depth] > 3) {
            $self->{paths}[$ctr][$current_depth] = 0;
        } else {
            $more_to_go = 1;
            last;
        }
    }

    # - TODO: we need to detect which paths are invalid, and skip them
    # - TODO: we need to detect if we've finished one path, and if so, stop iterating on that one
    # - TODO: we need to detect if we've finished all paths, and if so, return false

    return $more_to_go;
}


# "Vertically" is a direction in the game-tree:  the same direction as "depth first".
#
# This adds another layer to the bottom of the tree.
sub increment_vertically {
}


1;
