package Data::Clean::FromJSON;

# DATE
# VERSION

use 5.010001;
use strict;
use warnings;

use parent qw(Data::Clean);
use vars qw($creating_singleton);

sub new {
    my ($class, %opts) = @_;
    if (!%opts && !$creating_singleton) {
        warn "You are creating a new ".__PACKAGE__." object without customizing options. ".
            "You probably want to call get_cleanser() yet to get a singleton instead?";
    }

    $opts{"JSON::PP::Boolean"} //= ['deref_scalar_one_or_zero'];

    $class->SUPER::new(%opts);
}

sub get_cleanser {
    my $class = shift;
    local $creating_singleton = 1;
    state $singleton = $class->new;
    $singleton;
}

1;
# ABSTRACT: Clean data from JSON decoder

=head1 SYNOPSIS

 use Data::Clean::FromJSON;
 use JSON;
 my $cleanser = Data::Clean::FromJSON->get_cleanser;
 my $data    = JSON->new->decode('[true]'); # -> [bless(do{\(my $o=1)},"JSON::XS::Boolean")]
 my $cleaned = $cleanser->clean_in_place($data); # -> [1]


=head1 DESCRIPTION

This class can "clean" data that comes from a JSON encoder. Currently what it
does is:

=over

=item * Convert boolean objects to simple Perl values

=back


=head1 METHODS

=head2 CLASS->get_cleanser => $obj

Return a singleton instance, with default options. Use C<new()> if you want to
customize options.

=head2 CLASS->new() => $obj

=head2 $obj->clean_in_place($data) => $cleaned

Clean $data. Modify data in-place.

=head2 $obj->clone_and_clean($data) => $cleaned

Clean $data. Clone $data first.


=head1 ENVIRONMENT

LOG_CLEANSER_CODE


=head1 FAQ

=head2 Why am I getting 'Modification of a read-only value attempted at lib/Data/Clean.pm line xxx'?

[2013-10-15 ] This is also from Data::Clone::clone() when it encounters
JSON::{PP,XS}::Boolean objects. You can use clean_in_place() instead of
clone_and_clean(), or clone your data using other cloner like L<Sereal>.

=cut
