
use strict;
use warnings;

use Test::More tests => 24;
use Test::Exception;

use Math::BigFloat;
use Math::BigInt;
use DateTime;
use DateTime::Duration;
use IO::File;
use URI;

{
    package TestTypesXMLSchema;
    use Moose;

    use MooseX::Types::XMLSchema qw( :all );

    has 'string'       => ( is => 'rw', isa => 'xs:string' );
    has 'int'          => ( is => 'rw', isa => 'xs:int' );
    has 'integer'      => ( is => 'rw', isa => 'xs:integer' );
    has 'integer_co'   => ( is => 'rw', isa => 'xs:integer', coerce => 1 );
    has 'posint'       => ( is => 'rw', isa => 'xs:unsignedInt' );
    has 'boolean'      => ( is => 'rw', isa => 'xs:boolean' );
    has 'float'        => ( is => 'rw', isa => 'xs:float' );
    has 'double'       => ( is => 'rw', isa => 'xs:double' );
    has 'decimal'      => ( is => 'rw', isa => 'xs:decimal' );
    has 'float_co'        => ( is => 'rw', isa => 'xs:float', coerce => 1 );
    has 'double_co'       => ( is => 'rw', isa => 'xs:double', coerce => 1 );
    has 'decimal_co'      => ( is => 'rw', isa => 'xs:decimal', coerce => 1 );

    has 'duration'     => ( is => 'rw', isa => 'xs:duration' );
    has 'datetime'     => ( is => 'rw', isa => 'xs:dateTime' );
    has 'time'         => ( is => 'rw', isa => 'xs:time' );
    has 'date'         => ( is => 'rw', isa => 'xs:date' );
    has 'gYearMonth'   => ( is => 'rw', isa => 'xs:gYearMonth' );
    has 'gYear'        => ( is => 'rw', isa => 'xs:gYear' );
    has 'gMonthDay'    => ( is => 'rw', isa => 'xs:gMonthDay' );
    has 'gDay'         => ( is => 'rw', isa => 'xs:gDay' );
    has 'gMonth'       => ( is => 'rw', isa => 'xs:gMonth' );

    has 'duration_co'     => ( is => 'rw', isa => 'xs:duration', coerce => 1 );
    has 'datetime_co'     => ( is => 'rw', isa => 'xs:dateTime', coerce => 1 );
    has 'time_co'         => ( is => 'rw', isa => 'xs:time', coerce => 1 );
    has 'date_co'         => ( is => 'rw', isa => 'xs:date', coerce => 1 );
    has 'gYearMonth_co'   => ( is => 'rw', isa => 'xs:gYearMonth', coerce => 1 );
    has 'gYear_co'        => ( is => 'rw', isa => 'xs:gYear', coerce => 1 );
    has 'gMonthDay_co'    => ( is => 'rw', isa => 'xs:gMonthDay', coerce => 1 );
    has 'gDay_co'         => ( is => 'rw', isa => 'xs:gDay', coerce => 1 );
    has 'gMonth_co'       => ( is => 'rw', isa => 'xs:gMonth', coerce => 1 );

    has 'base64Binary' => ( is => 'rw', isa => 'xs:base64Binary' );
    has 'base64Binary_co' => ( is => 'rw', isa => 'xs:base64Binary', coerce => 1 );

    has 'anyURI'       => ( is => 'rw', isa => 'xs:anyURI' );
    has 'anyURI_uri'       => ( is => 'rw', isa => 'xs:anyURI', coerce => 1 );

    has 'nonPositiveInteger' => ( is => 'rw', isa => 'xs:nonPositiveInteger' );
    has 'positiveInteger'    => ( is => 'rw', isa => 'xs:positiveInteger' );
    has 'nonNegativeInteger' => ( is => 'rw', isa => 'xs:nonNegativeInteger' );
    has 'negativeInteger'    => ( is => 'rw', isa => 'xs:negativeInteger' );

}

my $o;
subtest "setup" => sub {
    ok($o = TestTypesXMLSchema->new(), "created base object");
};

subtest "xs:string" => sub {
    plan tests => 2;
    lives_ok { $o->string('text value') } 'valid xs:string <- text';
    is $o->string, 'text value', '...value correct';
};

subtest "xs:int" => sub {
    plan tests => 3;
    lives_ok { $o->int(123) } 'valid xs:int<- 123';
    is $o->int, 123, '...value correct';
    dies_ok { $o->int('text') } 'invalid xs:int<- text';
};

subtest "xs:integer" => sub {
    plan tests => 8;
    lives_ok { $o->integer( new Math::BigInt 123 ) } 'valid xs:integer <- Math::BigInt(123)';
    is $o->integer, 123, '...value correct';
    lives_ok { $o->integer_co( 123 ) } 'valid xs:integer <- 123 (coerce)';
    is $o->integer, 123, '...value correct';
    dies_ok { $o->integer('text') } 'invalid xs:integer <- text';
    dies_ok { $o->integer_co('text') } 'invalid xs:integer <- text (coerce)';
    isa_ok($o->integer, 'Math::BigInt', '$o->integer');
    isa_ok($o->integer_co, 'Math::BigInt', '$o->integer_co (coerce)');
};

subtest "xs:unsignedint" => sub {
    plan tests => 5;
    lives_ok { $o->posint(123) } 'valid xs:unsignedInt <- 123';
    is $o->posint, 123, '...value correct';
    dies_ok { $o->posint('text') } 'invalid xs:unsignedInt <- text';
    dies_ok { $o->posint(-1) } ' invalid xs:unsignedInt <- -1';
    my $too_big = 2 ** 32;
    dies_ok { $o->posint($too_big) } " invalid xs:unsignedInt <- $too_big";
};

subtest "xs:boolean" => sub {
    plan tests => 3;
    lives_ok { $o->boolean(1) } 'valid xs:boolean <- 1';
    is $o->boolean, 1, '...value correct';
    dies_ok { $o->boolean('false') } 'invalid xs:boolean <- false';
};

subtest "xs:float" => sub {
    plan tests => 7;
    lives_ok { $o->float( new Math::BigFloat 123.4567) } 'valid xs:float <- 123.4567';
    is $o->float, 123.4567, '...value correct';
    lives_ok { $o->float_co(123.4567) } 'valid xs:float <- 123.4567 (coerce)';
    is $o->float_co, 123.4567, '...value correct';
    lives_ok { $o->float( new Math::BigFloat 12.78e-2) } 'valid xs:float <- 12.78e-2';
    is $o->float, 12.78e-2, '...value correct';
    dies_ok { $o->float_co( '12.78f-2') } 'invalid xs:float <- 12.78f-2';
};

subtest "xs:double" => sub {
    plan tests => 7;
    lives_ok { $o->double( new Math::BigFloat 123.4567) } 'valid xs:double <- 123.4567';
    is $o->double, 123.4567, '...value correct';
    lives_ok { $o->double_co(123.4567) } 'valid xs:double <- 123.4567 (coerce)';
    is $o->double, 123.4567, '...value correct';
    lives_ok { $o->double( new Math::BigFloat 12.78e-2) } 'valid xs:double <- 12.78e-2';
    is $o->double, 12.78e-2, '...value correct';
    dies_ok { $o->double( new Math::BigFloat '12.78f-2') } 'invalid xs:double <- 12.78f-2';
};

subtest "xs:decimal" => sub {
    plan tests => 6;
    lives_ok { $o->decimal( new Math::BigFloat 123.45) } 'valid xs:decimal <- 123.45';
    is $o->decimal, 123.45, '...value correct';
    lives_ok { $o->decimal_co(123.45) } 'valid xs:decimal <- 123.45 (coerce)';
    is $o->decimal, 123.45, '...value correct';
    lives_ok { $o->decimal( new Math::BigFloat 12.3456e+2) } 'valid xs:decimal <- 12.3456e+2';
    is $o->decimal, 12.3456e+2, '...value correct';
};

my $duration = DateTime::Duration->new(
    years => 3,
    days => 15,
    seconds => 37,
);
my $dt1 = DateTime->new( year   => 1964,
                       month  => 10,
                       day    => 16,
                       hour   => 16,
                       minute => 12,
                       second => 47,
                       time_zone  => 'America/Chicago',
                     );
my $dt2 = DateTime->new( year   => 1964,
                       month  => 12,
                       day    => 26,
                       hour   => 16,
                       minute => 36,
                       second => 24,
                       time_zone  => 'America/Chicago',
                     );

subtest "xs:duration" => sub {
    plan tests => 18;
    dies_ok { $o->duration( '3 years' ) } 'invalid xs:duration <- Str';
    dies_ok { $o->duration( $duration ) } 'invalid xs:duration <- DateTime::Duration';

    lives_ok { $o->duration( 'P3Y0M15DT0H0M37S' ) } 'valid xs:duration <- Str';
    is $o->duration, 'P3Y0M15DT0H0M37S', '...value correct';

    lives_ok { $o->duration_co( $duration ) } 'valid xs:duration <- DateTime::Duration';
    is $o->duration_co, 'P3Y0M15DT0H0M37S', '...value correct';

    lives_ok { $o->duration_co( $dt1 - $dt2 ) } 'valid xs:duration <- DateTime1 - DateTime2';
    is $o->duration_co, '-P0Y2M10DT0H23M37S', '...value correct';

    my @nanosecs = ( 
        '123' => 'P3Y0M15DT0H0M37.000000123S',
        '12300' => 'P3Y0M15DT0H0M37.0000123S',
        '1230000' => 'P3Y0M15DT0H0M37.00123S',
        '123000000' => 'P3Y0M15DT0H0M37.123S',
        '1230000000' => 'P3Y0M15DT0H0M38.23S',
    );
    while ( my ($ns, $expected) = splice(@nanosecs,0, 2) ) {
        my $ns_duration = $duration->clone;
        $ns_duration->add( nanoseconds => $ns );
        lives_ok { $o->duration_co( $ns_duration ) } 'valid xs:duration <- DateTime::Duration (with ns)';
        is $o->duration_co, $expected, "...value correct";
    }
};

subtest "xs:datetime" => sub {
    plan tests => 20;
    lives_ok { $o->datetime( '1964-10-16T16:12:47-05:00' ) } 'valid xs:dateTime <- Str';
    is $o->datetime, '1964-10-16T16:12:47-05:00', '...value correct';

    lives_ok { $o->datetime( '1964-10-16T16:12:47.123-05:00' ) } 'valid xs:dateTime <- Str';
    is $o->datetime, '1964-10-16T16:12:47.123-05:00', '...value correct';

    lives_ok { $o->datetime_co( $dt1 ) } 'valid xs:dateTime <- DateTime';
    is $o->datetime_co, '1964-10-16T16:12:47-05:00', '...value correct';

    $dt1->set_time_zone('Asia/Tokyo');
    lives_ok { $o->datetime_co( $dt1 ) } 'valid xs:dateTime <- DateTime(Tokyo)';
    is $o->datetime_co, '1964-10-17T06:12:47+09:00', '...value correct';

    $dt1->set_time_zone('UTC');
    lives_ok { $o->datetime_co( $dt1 ) } 'valid xs:dateTime <- DateTime(UTC)';
    is $o->datetime_co, '1964-10-16T21:12:47Z', '...value correct';

    my @nanosecs = ( 
        '123' => '1964-10-16T21:12:47.000000123Z',
        '12300' => '1964-10-16T21:12:47.0000123Z',
        '1230000' => '1964-10-16T21:12:47.00123Z',
        '123000000' => '1964-10-16T21:12:47.123Z',
        '1230000000' => '1964-10-16T21:12:48.23Z',
    );
    while ( my ($ns, $expected) = splice(@nanosecs,0, 2) ) {
        my $ns_dt = $dt1->clone;
        $ns_dt->set_nanosecond( $ns );
        lives_ok { $o->datetime_co( $ns_dt ) } 'valid xs:dateTime <- DateTime (with ns)';
        is $o->datetime_co, $expected, '...value correct';
    }
};

subtest "xs:time" => sub {
    plan tests => 16;
    lives_ok { $o->time( '06:12:47+09:00' ) } 'valid xs:time <- Str';
    is $o->time, '06:12:47+09:00', '...value correct';

    lives_ok { $o->time( '06:12:47.123+09:00' ) } 'valid xs:time <- Str';
    is $o->time, '06:12:47.123+09:00', '...value correct';

    $dt1->set_time_zone('Asia/Tokyo');
    lives_ok { $o->time_co( $dt1 ) } 'valid xs:time <- DateTime';
    is $o->time_co, '06:12:47+09:00', '...value correct';

    my @nanosecs = ( 
        '123' => '06:12:47.000000123+09:00',
        '12300' => '06:12:47.0000123+09:00',
        '1230000' => '06:12:47.00123+09:00',
        '123000000' => '06:12:47.123+09:00',
        '1230000000' => '06:12:48.23+09:00',
    );
    while ( my ($ns, $expected) = splice(@nanosecs,0, 2) ) {
        my $ns_dt = $dt1->clone;
        $ns_dt->set_nanosecond( $ns );
        lives_ok { $o->time_co( $ns_dt ) } 'valid xs:time <- DateTime (with ns)';
        is $o->time_co, $expected, '...value correct';
    }
};

subtest "xs:date" => sub {
    plan tests => 4;
    lives_ok { $o->date( '1964-10-16' ) } 'valid xs:date <- Str';
    is $o->date, '1964-10-16', '...value correct';
    $dt1->set_time_zone('UTC');
    lives_ok { $o->date_co( $dt1 ) } 'valid xs:date <- DateTime';
    is $o->date_co, '1964-10-16', '...value correct';
};

subtest "xs:gYearMonth" => sub {
    plan tests => 6;
    lives_ok { $o->gYearMonth( '1964-10' ) } 'valid xs:gYearMonth <- Str';
    is $o->gYearMonth, '1964-10', '...value correct';
    lives_ok { $o->gYearMonth_co( [1856, 4] ) } 'valid xs:gYearMonth <- ArrayRef';
    is $o->gYearMonth_co, '1856-04', '...value correct';
    lives_ok { $o->gYearMonth_co( $dt1 ) } 'valid xs:gYearMonth <- DateTime';
    is $o->gYearMonth_co, '1964-10', '...value correct';
};

subtest "xs:gYear" => sub {
    plan tests => 4;
    lives_ok { $o->gYear( '1964' ) } 'valid xs:gYear <- Str';
    is $o->gYear, '1964', '...value correct';
    lives_ok { $o->gYear_co( $dt1 ) } 'valid xs:gYear <- DateTime';
    is $o->gYear_co, '1964', '...value correct';
};

subtest "xs:gMonthDay" => sub {
    plan tests => 6;
    lives_ok { $o->gMonthDay( '--10-16' ) } 'valid xs:gMonthDay <- Str';
    is $o->gMonthDay, '--10-16', '...value correct';
    lives_ok { $o->gMonthDay_co( [4, 3] ) } 'valid xs:gMonthDay <- ArrayRef';
    is $o->gMonthDay_co, '--04-03', '...value correct';
    lives_ok { $o->gMonthDay_co( $dt1 ) } 'valid xs:gMonthDay <- DateTime';
    is $o->gMonthDay_co, '--10-16', '...value correct';
};

subtest "xs:gDay" => sub {
    plan tests => 6;
    lives_ok { $o->gDay( '---16' ) } 'valid xs:gDay <- Str';
    is $o->gDay, '---16', '...value correct';
    lives_ok { $o->gDay_co( 16 ) } 'valid xs:gDay <- Int';
    is $o->gDay_co, '---16', '...value correct';
    lives_ok { $o->gDay_co( $dt1 ) } 'valid xs:gDay <- DateTime';
    is $o->gDay_co, '---16', '...value correct';
};

subtest "xs:gMonth" => sub {
    plan tests => 4;
    lives_ok { $o->gMonth( '--10' ) } 'valid xs:gMonth <- Str';
    is $o->gMonth, '--10', '...value correct';
    lives_ok { $o->gMonth_co( $dt1 ) } 'valid xs:gMonth <- DateTime';
    is $o->gMonth_co, '--10', '...value correct';

};

subtest "xs:base64Binary" => sub {
    plan tests => 2;
    my $fh = IO::File->new($0, "r");
    lives_ok { $o->base64Binary_co( $fh ) } 'valid xs:base64Binary <- IO::File';
    like $o->base64Binary_co, qr/^[a-zA-Z0-9=\+]+$/m, '...value correct';

};

subtest "xs:anyURI" => sub {
    plan tests => 4;
    lives_ok { $o->anyURI( 'http://www.perl.org/?username=foo&password=bar' ) } 'valid xs:anyURI <- Str';
    is $o->anyURI, 'http://www.perl.org/?username=foo&password=bar', '...value correct';

    my $uri = URI->new('http://www.perl.org/');
    $uri->query_form( username => 'foo', password => 'bar');
    lives_ok { $o->anyURI_uri( $uri ) } 'valid xs:anyURI <- URI';
    is $o->anyURI_uri, 'http://www.perl.org/?username=foo&password=bar', '...value correct';

};

subtest "xs:nonPositiveInteger" => sub {
    plan tests => 3;
    lives_ok { $o->nonPositiveInteger( -123 ) } 'valid xs:nonPositiveInteger <- Int';
    is $o->nonPositiveInteger, -123, '...value correct';
    dies_ok { $o->nonPositiveInteger( 123 ) } 'invalid xs:nonPositiveInteger <- Int';
};

subtest "xs:positiveInteger" => sub {
    plan tests => 3;
    lives_ok { $o->positiveInteger( 123 ) } 'valid xs:positiveInteger <- Int';
    is $o->positiveInteger, 123, '...value correct';
    dies_ok { $o->positiveInteger( -123 ) } 'invalid xs:positiveInteger <- Int';
};

subtest "xs:nonNegativeInteger" => sub {
    plan tests => 3;
    lives_ok { $o->nonNegativeInteger( 123 ) } 'valid xs:nonNegativeInteger <- Int';
    is $o->nonNegativeInteger, 123, '...value correct';
    dies_ok { $o->nonnegativeInteger( -123 ) } 'invalid xs:nonnegativeInteger <- Int';
};

subtest "xs:negativeInteger" => sub {
    plan tests => 3;
    lives_ok { $o->negativeInteger( -123 ) } 'valid xs:negativeInteger <- Int';
    is $o->negativeInteger, -123, '...value correct';
    dies_ok { $o->negativeInteger( 123 ) } 'invalid xs:negativeInteger <- Int';
};

