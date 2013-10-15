package Data::Clean::FromJSON;

use 5.010001;
use strict;
use warnings;

use parent qw(Data::Clean::Base);

# VERSION

sub new {
    my ($class, %opts) = @_;
    $opts{"JSON::XS::Boolean"} //= ['one_or_zero'];
    $opts{"JSON::PP::Boolean"} //= ['one_or_zero'];
    $class->SUPER::new(%opts);
}

1;
# ABSTRACT: Clean data from JSON decoder

=head1 SYNOPSIS

 use Data::Clean::FromJSON;
 use JSON;
 my $cleanser = Data::Clean::FromJSON->new;
 my $data    = JSON->new->decode('[true]'); # -> [bless(do{\(my $o=1)},"JSON::XS::Boolean")]
 my $cleaned = $cleanser->clean_in_place($data); # -> [1]


=head1 DESCRIPTION

This class can convert L<JSON::PP::Boolean> (or C<JSON::XS::Boolean>) objects to
1/0 values.


=head1 METHODS

=head2 new(%opts) => $obj

Create a new instance. For list of known options, see L<Data::Clean::Base>.
Data::Clean::FromJSON sets some defaults.

    "JSON::PP::Boolean" => ['one_or_zero']
    "JSON::XS::Boolean" => ['one_or_zero']

=head2 $obj->clean_in_place($data) => $cleaned

Clean $data. Modify data in-place.

=head2 $obj->clone_and_clean($data) => $cleaned

Clean $data. Clone $data first.

=cut