use Test::More tests => 787;
BEGIN { use_ok('Finance::QIF') }

testfile( "Read ", "t/test.qif" );
my $in  = Finance::QIF->new( file => "t/test.qif" );
my $out = Finance::QIF->new( file => ">t/write.qif" );

my $header = "";
while ( my $record = $in->next() ) {
    if ( $header ne $record->{header} ) {
        $out->header( $record->{header} );
        $header = $record->{header};
    }
    $out->write($record);
}

$in->close();
$out->close();
testfile( "Write ", "t/write.qif" );

# Need a test for confirming we don't interfere with other open files
# reading input with different line seperator.

sub testfile {
    my $test = shift;
    my $file = shift;
    my $qif  = Finance::QIF->new( file => $file );

    # account tests
    {
        my $record = $qif->next();
        ok( $record->{header}      eq "Account",       $test . "Account" );
        ok( $record->{name}        eq "Asset",         $test . "Account" );
        ok( $record->{description} eq "Sample Asset",  $test . "Account" );
        ok( $record->{tax}         eq "",              $test . "Account" );
        ok( $record->{note}        eq "Note on Asset", $test . "Account" );
        ok( $record->{type}        eq "Oth A",         $test . "Account" );
        ok( $record->{balance}     eq "25,000.00",     $test . "Account" );
        my $record = $qif->next();
        ok( $record->{header}      eq "Account",         $test . "Account" );
        ok( $record->{name}        eq "Bank",            $test . "Account" );
        ok( $record->{description} eq "Sample Bank",     $test . "Account" );
        ok( $record->{tax}         eq "",                $test . "Account" );
        ok( $record->{note}        eq "Notes on Sample", $test . "Account" );
        ok( $record->{type}        eq "Bank",            $test . "Account" );
        ok( $record->{balance}     eq "1,465.00",        $test . "Account" );
        my $record = $qif->next();
        ok( $record->{header}      eq "Account",     $test . "Account" );
        ok( $record->{name}        eq "Cash",        $test . "Account" );
        ok( $record->{description} eq "Sample Cash", $test . "Account" );
        ok( $record->{tax}     eq "",             $test . "Account" );
        ok( $record->{note}    eq "Note on Cash", $test . "Account" );
        ok( $record->{type}    eq "Cash",         $test . "Account" );
        ok( $record->{balance} eq "0.00",         $test . "Account" );
        my $record = $qif->next();
        ok( $record->{header}      eq "Account",      $test . "Account" );
        ok( $record->{name}        eq "Credit Card",  $test . "Account" );
        ok( $record->{description} eq "Sample Card",  $test . "Account" );
        ok( $record->{limit}       eq "15,000.00",    $test . "Account" );
        ok( $record->{tax}         eq "",             $test . "Account" );
        ok( $record->{note}        eq "Note on Card", $test . "Account" );
        ok( $record->{type}        eq "CCard",        $test . "Account" );
        ok( $record->{balance}     eq "0.00",         $test . "Account" );
        my $record = $qif->next();
        ok( $record->{header}      eq "Account",           $test . "Account" );
        ok( $record->{name}        eq "Liability",         $test . "Account" );
        ok( $record->{description} eq "Sample Liability",  $test . "Account" );
        ok( $record->{tax}         eq "",                  $test . "Account" );
        ok( $record->{note}        eq "Note on Liability", $test . "Account" );
        ok( $record->{type}        eq "Oth L",             $test . "Account" );
        ok( $record->{balance}     eq "50,000.00",         $test . "Account" );
        my $record = $qif->next();
        ok( $record->{header}      eq "Account",      $test . "Account" );
        ok( $record->{name}        eq "Mutual Fund",  $test . "Account" );
        ok( $record->{description} eq "Sample Fund",  $test . "Account" );
        ok( $record->{tax}         eq "",             $test . "Account" );
        ok( $record->{note}        eq "Note on Fund", $test . "Account" );
        ok( $record->{type}        eq "Mutual",       $test . "Account" );
        ok( $record->{balance}     eq "672.87",       $test . "Account" );
        my $record = $qif->next();
        ok( $record->{header}      eq "Account",           $test . "Account" );
        ok( $record->{name}        eq "Portfolio",         $test . "Account" );
        ok( $record->{description} eq "Sample Portfolio",  $test . "Account" );
        ok( $record->{tax}         eq "",                  $test . "Account" );
        ok( $record->{note}        eq "Note on portfolio", $test . "Account" );
        ok( $record->{type}        eq "Port",              $test . "Account" );
        ok( $record->{balance}     eq "2,651.00",          $test . "Account" );
    }

    # security tests
    for ( my $count = 0 ; $count < 2 ; $count++ ) {
        my $record = $qif->next();
        ok( $record->{header} eq "Type:Security", $test . "Security" );
    }

    # payee tests
    # need to find appropriate way to test missing defiend fields that
    # this test currently correctly generates since Y is not supported.
    for ( my $count = 0 ; $count < 1 ; $count++ ) {
        my $record = $qif->next();
        ok( $record->{header} eq "Type:Payee", $test . "Payee" );
    }

    # category tests
    for ( my $count = 0 ; $count < 96 ; $count++ ) {
        my $record = $qif->next();
        ok( $record->{header} eq "Type:Cat", $test . "Category" );
    }

    # budget tests
    {
        for ( my $count = 0 ; $count < 17 ; $count++ ) {
            my $record = $qif->next();
            ok( $record->{header} eq "Type:Budget", $test . "Budget" );
        }
        my $record = $qif->next();
        ok( $record->{header}      eq "Type:Budget", $test . "Budget" );
        ok( $record->{name}        eq "Groceries",   $test . "Budget" );
        ok( $record->{description} eq "Groceries",   $test . "Budget" );
        ok( $record->{budget}[0]   eq "-100.00",     $test . "Budget" );
        ok( $record->{budget}[1]   eq "-100.00",     $test . "Budget" );
        ok( $record->{budget}[2]   eq "-100.00",     $test . "Budget" );
        ok( $record->{budget}[3]   eq "-100.00",     $test . "Budget" );
        ok( $record->{budget}[4]   eq "-100.00",     $test . "Budget" );
        ok( $record->{budget}[5]   eq "-100.00",     $test . "Budget" );
        ok( $record->{budget}[6]   eq "-100.00",     $test . "Budget" );
        ok( $record->{budget}[7]   eq "-100.00",     $test . "Budget" );
        ok( $record->{budget}[8]   eq "-100.00",     $test . "Budget" );
        ok( $record->{budget}[9]   eq "-100.00",     $test . "Budget" );
        ok( $record->{budget}[10]  eq "-100.00",     $test . "Budget" );
        ok( $record->{budget}[11]  eq "-100.00",     $test . "Budget" );
        for ( my $count = 0 ; $count < 78 ; $count++ ) {
            my $record = $qif->next();
            ok( $record->{header} eq "Type:Budget", $test . "Budget" );
        }
    }

    # Class tests
    for ( my $count = 0 ; $count < 2 ; $count++ ) {
        my $record = $qif->next();
        ok( $record->{header} eq "Type:Class", $test . "Class" );
    }

    # Oth A test
    {
        my $record = $qif->next();
        ok( $record->{header}  eq "Account",   $test . "Oth A" );
        ok( $record->{name}    eq "Asset",     $test . "Oth A" );
        ok( $record->{type}    eq "Oth A",     $test . "Oth A" );
        ok( $record->{balance} eq "25,000.00", $test . "Oth A" );
        for ( my $count = 0 ; $count < 2 ; $count++ ) {
            my $record = $qif->next();
            ok( $record->{header} eq "Type:Oth A", $test . "Oth A" );
        }
    }

    # Bank test
    {
        my $record = $qif->next();
        ok( $record->{header}  eq "Account",  $test . "Bank" );
        ok( $record->{name}    eq "Bank",     $test . "Bank" );
        ok( $record->{type}    eq "Bank",     $test . "Bank" );
        ok( $record->{balance} eq "1,465.00", $test . "Bank" );
        my $record = $qif->next();
        ok( $record->{header}   eq "Type:Bank",       $test . "Bank" );
        ok( $record->{date}     eq "1/10/06",         $test . "Bank" );
        ok( $record->{payee}    eq "Opening Balance", $test . "Bank" );
        ok( $record->{memo}     eq "",                $test . "Bank" );
        ok( $record->{amount}   eq "0.00",            $test . "Bank" );
        ok( $record->{address}  eq "",                $test . "Bank" );
        ok( $record->{status}   eq "X",               $test . "Bank" );
        ok( $record->{category} eq "[Bank]",          $test . "Bank" );
        my $record = $qif->next();
        ok( $record->{header}              eq "Type:Bank", $test . "Bank" );
        ok( $record->{date}                eq "1/10/06",   $test . "Bank" );
        ok( $record->{payee}               eq "Paycheck",  $test . "Bank" );
        ok( $record->{memo}                eq "",          $test . "Bank" );
        ok( $record->{amount}              eq "1,690.00",  $test . "Bank" );
        ok( $record->{address}             eq "",          $test . "Bank" );
        ok( $record->{category}            eq "Salary",    $test . "Bank" );
        ok( $record->{splits}[0]{category} eq "Salary",    $test . "Bank" );
        ok( $record->{splits}[0]{memo}     eq "",          $test . "Bank" );
        ok( $record->{splits}[0]{amount}   eq "2,000.00",  $test . "Bank" );
        ok( $record->{splits}[1]{category} eq "Payroll Taxes, Self:Federal",
            $test . "Bank" );
        ok( $record->{splits}[1]{memo}   eq "",        $test . "Bank" );
        ok( $record->{splits}[1]{amount} eq "-250.00", $test . "Bank" );
        ok( $record->{splits}[2]{category} eq "Payroll Taxes, Self:Soc Sec",
            $test . "Bank" );
        ok( $record->{splits}[2]{memo}   eq "",       $test . "Bank" );
        ok( $record->{splits}[2]{amount} eq "-50.00", $test . "Bank" );
        ok( $record->{splits}[3]{category} eq "Payroll Taxes, Self:Medicare",
            $test . "Bank" );
        ok( $record->{splits}[3]{memo}   eq "",       $test . "Bank" );
        ok( $record->{splits}[3]{amount} eq "-10.00", $test . "Bank" );
        my $record = $qif->next();
        ok( $record->{header}   eq "Type:Bank", $test . "Bank" );
        ok( $record->{date}     eq "1/17/06",   $test . "Bank" );
        ok( $record->{payee}    eq "Safeway",   $test . "Bank" );
        ok( $record->{memo}     eq "",          $test . "Bank" );
        ok( $record->{amount}   eq "-100.00",   $test . "Bank" );
        ok( $record->{address}  eq "",          $test . "Bank" );
        ok( $record->{category} eq "Groceries", $test . "Bank" );
        my $record = $qif->next();
        ok( $record->{header}              eq "Type:Bank", $test . "Bank" );
        ok( $record->{date}                eq "2/17/06",   $test . "Bank" );
        ok( $record->{payee}               eq "Safeway",   $test . "Bank" );
        ok( $record->{memo}                eq "",          $test . "Bank" );
        ok( $record->{amount}              eq "-125.00",   $test . "Bank" );
        ok( $record->{address}             eq "",          $test . "Bank" );
        ok( $record->{number}              eq ">>>>>",     $test . "Bank" );
        ok( $record->{category}            eq "Groceries", $test . "Bank" );
        ok( $record->{splits}[0]{category} eq "Groceries", $test . "Bank" );
        ok( $record->{splits}[0]{memo}     eq "",          $test . "Bank" );
        ok( $record->{splits}[0]{amount}   eq "-100.00",   $test . "Bank" );
        ok( $record->{splits}[1]{category} eq "Misc",      $test . "Bank" );
        ok( $record->{splits}[1]{memo}     eq "",          $test . "Bank" );
        ok( $record->{splits}[1]{amount}   eq "-25.00",    $test . "Bank" );
    }

    # Cash test
    {
        my $record = $qif->next();
        ok( $record->{header}  eq "Account", $test . "Cash" );
        ok( $record->{name}    eq "Cash",    $test . "Cash" );
        ok( $record->{type}    eq "Cash",    $test . "Cash" );
        ok( $record->{balance} eq "0.00",    $test . "Cash" );
        my $record = $qif->next();
        ok( $record->{header}   eq "Type:Cash",       $test . "Cash" );
        ok( $record->{date}     eq "1/10/06",         $test . "Cash" );
        ok( $record->{payee}    eq "Opening Balance", $test . "Cash" );
        ok( $record->{memo}     eq "",                $test . "Cash" );
        ok( $record->{amount}   eq "0.00",            $test . "Cash" );
        ok( $record->{address}  eq "",                $test . "Cash" );
        ok( $record->{status}   eq "X",               $test . "Cash" );
        ok( $record->{category} eq "[Cash]",          $test . "Cash" );
    }

    # Credit Card test
    {
        my $record = $qif->next();
        ok( $record->{header}  eq "Account",     $test . "Credit Card" );
        ok( $record->{name}    eq "Credit Card", $test . "Credit Card" );
        ok( $record->{limit}   eq "15,000.00",   $test . "Credit Card" );
        ok( $record->{type}    eq "CCard",       $test . "Credit Card" );
        ok( $record->{balance} eq "0.00",        $test . "Credit Card" );
        my $record = $qif->next();
        ok( $record->{header}   eq "Type:CCard",      $test . "Credit Card" );
        ok( $record->{date}     eq "1/10/06",         $test . "Credit Card" );
        ok( $record->{payee}    eq "Opening Balance", $test . "Credit Card" );
        ok( $record->{memo}     eq "",                $test . "Credit Card" );
        ok( $record->{amount}   eq "0.00",            $test . "Credit Card" );
        ok( $record->{address}  eq "",                $test . "Credit Card" );
        ok( $record->{status}   eq "X",               $test . "Credit Card" );
        ok( $record->{category} eq "[Credit Card]",   $test . "Credit Card" );
    }

    # Liability test
    {
        my $record = $qif->next();
        ok( $record->{header}  eq "Account",   $test . "Liability" );
        ok( $record->{name}    eq "Liability", $test . "Liability" );
        ok( $record->{type}    eq "Oth L",     $test . "Liability" );
        ok( $record->{balance} eq "50,000.00", $test . "Liability" );
        my $record = $qif->next();
        ok( $record->{header}   eq "Type:Oth L",      $test . "Liability" );
        ok( $record->{date}     eq "1/10/06",         $test . "Liability" );
        ok( $record->{payee}    eq "Opening Balance", $test . "Liability" );
        ok( $record->{memo}     eq "",                $test . "Liability" );
        ok( $record->{amount}   eq "-50,000.00",      $test . "Liability" );
        ok( $record->{address}  eq "",                $test . "Liability" );
        ok( $record->{status}   eq "X",               $test . "Liability" );
        ok( $record->{category} eq "[Liability]",     $test . "Liability" );
    }

    # Mutual Fund test
    {
        my $record = $qif->next();
        ok( $record->{header}  eq "Account",     $test . "Mutual Fund" );
        ok( $record->{name}    eq "Mutual Fund", $test . "Mutual Fund" );
        ok( $record->{type}    eq "Mutual",      $test . "Mutual Fund" );
        ok( $record->{balance} eq "672.87",      $test . "Mutual Fund" );
        for ( my $count = 0 ; $count < 1 ; $count++ ) {
            my $record = $qif->next();
            ok( $record->{header} eq "Type:Invst", $test . "Mutual Fund" );
        }
    }

    # Portfolio test
    {
        my $record = $qif->next();
        ok( $record->{header}  eq "Account",   $test . "Portfolio" );
        ok( $record->{name}    eq "Portfolio", $test . "Portfolio" );
        ok( $record->{type}    eq "Port",      $test . "Portfolio" );
        ok( $record->{balance} eq "2,651.00",  $test . "Portfolio" );
        for ( my $count = 0 ; $count < 1 ; $count++ ) {
            my $record = $qif->next();
            ok( $record->{header} eq "Type:Invst", $test . "Portfolio" );
        }
    }

    # Prices test
    for ( my $count = 0 ; $count < 2 ; $count++ ) {
        my $record = $qif->next();
        ok( $record->{header} eq "Type:Prices", $test . "Prices" );
    }

    # Memorized test
    {
        my $record = $qif->next();
        ok( $record->{header}      eq "Type:Memorized", $test . "Memorized" );
        ok( $record->{amount}      eq "-50.00",         $test . "Memorized" );
        ok( $record->{payee}       eq "Safeway",        $test . "Memorized" );
        ok( $record->{memo}        eq "",               $test . "Memorized" );
        ok( $record->{transaction} eq "C",              $test . "Memorized" );
        my $record = $qif->next();
        ok( $record->{header}   eq "Type:Memorized", $test . "Memorized" );
        ok( $record->{amount}   eq "-1,140.17",      $test . "Memorized" );
        ok( $record->{payee}    eq "Bank",           $test . "Memorized" );
        ok( $record->{memo}     eq "",               $test . "Memorized" );
        ok( $record->{address}  eq "",               $test . "Memorized" );
        ok( $record->{category} eq "[Liability]",    $test . "Memorized" );
        ok( $record->{splits}[0]{category} eq "[Liability]",
            $test . "Memorized" );
        ok( $record->{splits}[0]{memo}   eq "principal", $test . "Memorized" );
        ok( $record->{splits}[0]{amount} eq "-952.67",   $test . "Memorized" );
        ok( $record->{splits}[1]{category} eq "Mortgage Int",
            $test . "Memorized" );
        ok( $record->{splits}[1]{memo}   eq "interest",  $test . "Memorized" );
        ok( $record->{splits}[1]{amount} eq "-187.50",   $test . "Memorized" );
        ok( $record->{first}             eq "2/1/06",    $test . "Memorized" );
        ok( $record->{years}             eq "4",         $test . "Memorized" );
        ok( $record->{made}              eq "0",         $test . "Memorized" );
        ok( $record->{periods}           eq "12",        $test . "Memorized" );
        ok( $record->{interest}          eq "4.5",       $test . "Memorized" );
        ok( $record->{balance}           eq "25,000.00", $test . "Memorized" );
        ok( $record->{loan}              eq "25,000.00", $test . "Memorized" );
        ok( $record->{transaction}       eq "P",         $test . "Memorized" );
    }
}

