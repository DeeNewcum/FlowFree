package FlowFree::InitialBoard;

# The initial positions for a board / a map / a level.

    use strict;
    use warnings;

    use Storable qw[dclone];
    use Data::Dumper;


# structure:
#       height          grid height (integer)
#       width           grid width (integer)
#       pairs           array.  Should be ordered  (see ordering below)
#           color, x1, y1, x2, y2
#                               The two dots that make up the start and end.
#                               Note that ORDER MATTERS, with the leftmost dot first,
#                               or if they're in the same column, then the topmost dot.
sub new {
    my $class = shift;

    my $self = { @_ };

    return bless $self, $class;
}


sub draw {
    my $self = shift;
    my $framebuffer = shift;        # a FlowFree::Framebuf object

    $framebuffer->resize( $self->{width}, $self->{height} );
    foreach my $pair (@{$self->{pairs}}) {
        my ($color, $x1, $y1, $x2, $y2) = @$pair;
        $framebuffer->draw_path($color, [$x1, $y1], [undef]);
        $framebuffer->draw_path($color, [$x2, $y2], [undef]);
    }
}

1;
