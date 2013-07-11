#!/usr/bin/perl  
#use warnings;


sub GETDISKPERCENTER
{
	@df=`df`;
	@tmp=split(/\s+/,$df[2]);
	return $tmp[4]+0;
}

while(1){
  my $disk_usage=&GETDISKPERCENTER;
  printf ("The Disk usage is %1.f%%",$disk_usage);
  if($disk_usage>10){
    print "\tThe Disk usage is high!";
   }
  print "\n";	
  $SLEEPTIME=5;
  sleep $SLEEPTIME;
}  

=pod
foreach(@tmp){
	print;
	print "\n";
}
=cut

=pod
open( my $fh, "df |") or die "$!"; 
while ( <$fh> ) { 
	print; 
} 
=cut
