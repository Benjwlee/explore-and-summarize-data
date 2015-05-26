use Carp;
use Data::Dumper;
#use POSIX;
use Text::CSV;
use Storable qw(dclone);
local $|=1;

my ($csv, $csv2, $iH, $oH, %banh, %subnoh, $debug, $colF, $row,
);

@a=(
"--Civil",
"Civil Service",
"Social Worker",
"Clergy",
"ReligiousClergy",
"Religious",
"--Medical",
"Dentist",
"Doctor",
"Medical Technician",
"Nurse's Aide",
"Nurse (LPN)",
"Nurse (RN)",
"--Professional",
"Judge",
"Accountant/CPA",
"Chemist",
"Computer Programmer",
"Engineer - Chemical",
"Engineer - Electrical",
"Engineer - Mechanical",
"Pilot - Private/Commercial",
"Pharmacist",
"Professional",
"Psychologist",
"Analyst",
"Architect",
"Attorney",
"Biologist",
"Scientist",
"--Sales",
"Car Dealer",
"Sales - Commission",
"Sales - Retail",
"Realtor",
"Retail Management",
"--Exec",
"Executive",
"Investor",
"--Assistant",
"Food Service",
"Food Service Management",
"Administrative Assistant",
"Clerical",
"Laborer",
"Waiter/Waitress",
"--SkilledLabor",
"Flight Attendant",
"Skilled Labor",
"Fireman",
"Police Officer/Correction Officer",
"Postal Service",
"Bus Driver",
"Construction",
"Truck Driver",
"Landscaping",
"--Military",
"Military Enlisted",
"Military Officer",
"--Other",
"Other",
"--School",
"Principal",
"Professor",
"Student - College Freshman",
"Student - College Graduate Student",
"Student - College Junior",
"Student - College Senior",
"Student - College Sophomore",
"Student - Community College",
"Student - Technical School",
"Teacher",
"Teacher's Aide",
"--Tradesman",
"Tradesman - Carpenter",
"Tradesman - Electrician",
"Tradesman - Mechanic",
"Tradesman - Plumber",
"--Homemaker",
"Homemaker",
);

%emptab=(
"Employed"=>2,
"Full-time"=>3,
"Not available"=>0,
"Not employed"=>-2,
"Other"=>1,
"Part-time"=>1,
"Retired"=>3,
"Self-employed"=>2,
""=>0,
);

$cnt=0;
foreach $a (@a) {
  if ($a=~/^--/) {
    ($cnt)=$a=~/^--(\w+)$/;
  } else {
    $abc{$a}=$cnt;
  }
}
open($iH, '<', "prosperLoanData5.csv");
open($oH, '>', "prosperLoanData.csv");

$csv=Text::CSV->new({ sep_char => ',', binary => 1, allow_loose_quotes=> 1 });
my ($fH, $pt)=@_;
$colF=$csv->getline($iH);
$csv->column_names($colF);
print $oH join(",",@{$colF}),",occupationCategory,empidx\n";
while ($row=$csv->getline_hr($iH)) {
  $occ=$row->{Occupation};
  $empsta=$row->{EmploymentStatus};
  $empdur=$row->{EmploymentStatusDuration};
  $loq=$row->{LoanOriginationQuarter};
  ($qq, $yy)=split(/ /,$loq);
  $row->{LoanOriginationQuarter}=$yy." ".$qq;
  $csv->print_hr($oH, $row);
  $empidxt=$empdur*$emptab{$empsta};
  print $oH ",$abc{$occ},$empidxt\n";
}
close $iH;
