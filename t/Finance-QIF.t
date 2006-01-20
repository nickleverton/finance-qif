use Test::More tests => 249;
BEGIN { use_ok('Finance::QIF') }

my $qif = Finance::QIF->new(file=>"test.qif");

# account tests
for (my $count=0; $count<7; $count++) {
  my $record=$qif->next();
  ok($record->{header} eq "Account","Account")
}

# security tests
for (my $count=0; $count<2; $count++) {
  my $record=$qif->next();
  ok($record->{header} eq "Type:Security","Security")
}

# payee tests
# need to find appropriate way to test missing defiend fields that this
# test currently correctly generates since Y is not supported.
for (my $count=0; $count<1; $count++) {
  my $record=$qif->next();
  ok($record->{header} eq "Type:Payee","Payee")
}

# category tests
for (my $count=0; $count<96; $count++) {
  my $record=$qif->next();
  ok($record->{header} eq "Type:Cat","Category")
}

# budget tests
for (my $count=0; $count<96; $count++) {
  my $record=$qif->next();
  ok($record->{header} eq "Type:Budget","Budget")
}

# Class tests
for (my $count=0; $count<2; $count++) {
  my $record=$qif->next();
  ok($record->{header} eq "Type:Class","Class")
}


# Oth A test
my $record=$qif->next();
ok($record->{header} eq "Account", "Oth A");
ok($record->{name} eq "Asset", "Oth A");
ok($record->{type} eq "Oth A", "Oth A");
ok($record->{balance} eq "25,000.00", "Oth A");
for (my $count=0; $count<2; $count++) {
  my $record=$qif->next();
  ok($record->{header} eq "Type:Oth A","Oth A")
}

# Bank test
my $record=$qif->next();
ok($record->{header} eq "Account", "Bank");
ok($record->{name} eq "Bank", "Bank");
ok($record->{type} eq "Bank", "Bank");
ok($record->{balance} eq "1,465.00", "Bank");
for (my $count=0; $count<4; $count++) {
  my $record=$qif->next();
  ok($record->{header} eq "Type:Bank","Bank")
}

# Cash test
my $record=$qif->next();
ok($record->{header} eq "Account", "Cash");
ok($record->{name} eq "Cash", "Cash");
ok($record->{type} eq "Cash", "Cash");
ok($record->{balance} eq "0.00", "Cash");
for (my $count=0; $count<1; $count++) {
  my $record=$qif->next();
  ok($record->{header} eq "Type:Cash","Cash")
}

# Credit Card test
my $record=$qif->next();
ok($record->{header} eq "Account", "Credit Card");
ok($record->{name} eq "Credit Card", "Credit Card");
ok($record->{limit} eq "15,000.00", "Credit Card");
ok($record->{type} eq "CCard", "Credit Card");
ok($record->{balance} eq "0.00", "Credit Card");
for (my $count=0; $count<1; $count++) {
  my $record=$qif->next();
  ok($record->{header} eq "Type:CCard","Credit Card")
}

# Liability test
my $record=$qif->next();
ok($record->{header} eq "Account", "Liability");
ok($record->{name} eq "Liability", "Liability");
ok($record->{type} eq "Oth L", "Liability");
ok($record->{balance} eq "50,000.00", "Liability");
for (my $count=0; $count<1; $count++) {
  my $record=$qif->next();
  ok($record->{header} eq "Type:Oth L","Liability")
}

# Mutual Fund test
my $record=$qif->next();
ok($record->{header} eq "Account", "Mutual Fund");
ok($record->{name} eq "Mutual Fund", "Mutual Fund");
ok($record->{type} eq "Mutual", "Mutual Fund");
ok($record->{balance} eq "672.87", "Mutual Fund");
for (my $count=0; $count<1; $count++) {
  my $record=$qif->next();
  ok($record->{header} eq "Type:Invst","Mutual Fund")
}

# Portfolio test
my $record=$qif->next();
ok($record->{header} eq "Account", "Portfolio");
ok($record->{name} eq "Portfolio", "Portfolio");
ok($record->{type} eq "Port", "Portfolio");
ok($record->{balance} eq "2,651.00", "Portfolio");
for (my $count=0; $count<1; $count++) {
  my $record=$qif->next();
  ok($record->{header} eq "Type:Invst","Portfolio")
}

# Prices test
for (my $count=0; $count<2; $count++) {
  my $record=$qif->next();
  ok($record->{header} eq "Type:Prices","Prices")
}

# Memorized test
for (my $count=0; $count<2; $count++) {
  my $record=$qif->next();
  ok($record->{header} eq "Type:Memorized","Memorized")
}

# Need a test for confirming we don't interfere with other open files reading
# input with different line seperator.
