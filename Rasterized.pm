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

    use strict;
    use warnings;

    use Storable qw[dclone];
    use Data::Dumper;

sub new {
    my $class = shift;

    my $self = {};

    return bless $self, $class;
}


1;
