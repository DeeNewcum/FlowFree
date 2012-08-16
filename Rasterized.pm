package FlowFree::Rasterized;

# Rasterized objects are a rasterized version of a specific PathSet.
#
# Rasterized objects are similar to Framebuf objects.  The difference is:
#       - Framebuf operations run infrequently, and so aren't expected to run quickly.
#       - Rasterized operatinos run very frequently, and so may need to be made efficient.
#               (for instance, being memoized, etc).
#       - While both Rasterized and Framebuf have to work correctly, Framebuf is the
#         last-line-of-defense.  Framebuf is used in debugging, and is used to ensure that other
#         parts of the code (inculding Rasterized) work correctly.
#               - as such, Rasterized will probably never have optimizations applied to it.
#       - Rasterized is intended to work hand-in-hand with PathSet.  The intended output of
#         Rasterized is a set of queries that PathSet will make.  The output of Framebuf
#         is human-readable output.
#         

    use strict;
    use warnings;

    use List::MoreUtils qw[ each_arrayref ];

    use Storable qw[dclone];
    use Data::Dumper;


# contents of an object:
# 
# ==== occupied_mask ====
#       One bit per cell.  Indicates whether that cell is occupied.
#       There are width * height bits.


# pass in one of these, to create a new object from:
#       - a Board
#       - a PathSet
#       - a Rasterized  (ie. clone it)
sub new {
    my $class = shift;
    my $create_from = shift;

    my $self;
    if (ref($create_from) eq 'FlowFree::Rasterized') {
        ## clone
        $self = bless { %$create_from }, $class;

    } elsif (ref($create_from) eq 'FlowFree::InitialBoard'
          || ref($create_from) eq 'FlowFree::PathSet') {
        my $board = ref($create_from) eq 'FlowFree::PathSet' ? $create_from->{board} : $create_from;
        $self = bless {
            width => $board->{width},
            height => $board->{height},
            occupied_mask => '',
        }, $class;
        $self->mark( $self->{width}, $self->{height} );      # allocate the full size

        if (ref($create_from) eq 'FlowFree::PathSet') {
            my $ea = each_arrayref($board->{pairs}, $create_from->{paths});
            while (my ($start, $path) = $ea->()) {
                my ($x, $y) = ($start->[1], $start->[2]);
                $self->mark($x, $y);
                foreach my $dir (@$path) {
                    $x += $::dir_delta[$dir][0];
                    $y += $::dir_delta[$dir][1];
                    $self->mark($x, $y);
                }
            }
        } else {
            # mark STARTING point as occupied -- but NOT the ending point
            foreach my $pair (@{$board->{pairs}}) {
                $self->mark($pair->[1], $pair->[2]);
            }
        }
    }

    return $self;
}


sub mark {
    my ($self, $x, $y) = @_;
    vec($self->{occupied_mask}, $y * $self->{width} + $x, 1) = 1;
}


sub is_marked {
    my ($self, $x, $y) = @_;
    vec($self->{occupied_mask}, $y * $self->{width} + $x, 1);
}


sub draw {
    my ($self, $framebuf) = @_;
    #print length($self->{occupied_mask}), "\n";
    #less(xxd($self->{occupied_mask}));
    #return;

    $framebuf->resize($self->{width}, $self->{height});
    my $ctr=0;
    for (my $y=0; $y<$self->{height}; $y++) {
        for (my $x=0; $x<$self->{width}; $x++) {
            if (vec($self->{occupied_mask}, $ctr, 1)) {
                #$framebuf->draw_character(231, [$x, $y], "\x{2588}");
                $framebuf->draw_character(231, [$x, $y], "X");
            }
            $ctr++;
        }
    }
    return $framebuf;
}



# run a scalar through an external filter, and capture the results
# first arg is a list-ref that specifies the filter-command
use autodie;
sub filter_thru {my$pid=open my$fout,'-|'or do{my$pid=open my$fin,'|-',@{shift()};print$fin @_;close$fin;waitpid$pid,0;exit;};
                 my@o=<$fout>;close$fout;waitpid$pid,0;wantarray?@o:join'',@o}

sub xxd {filter_thru(['xxd'],@_)}


# display a string to the user, via 'less'
sub less {my$pid=open my$less,"|less";print$less @_;close$less;waitpid$pid,0}


1;
