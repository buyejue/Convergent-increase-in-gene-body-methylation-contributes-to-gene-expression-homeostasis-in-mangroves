#!usr/bin/perl
use warnings;
use strict;

die "Usage: perl program <input> <temp_seq> <temp_mus> <output>",if (@ARGV != 8); # usage infromation
my($genome_faa,$genome_fas,$list,$temp_seq,$temp_mus,$temp_nus,$temp_codon,$out) = @ARGV;

open IN,$genome_faa or die "ERROR in IN: $!\n";
open (OUT,">$out") or die "Can not open the output_file:$!\n";
my $db;
my ($id,$seq);
while(my $line = <IN>){
    chomp $line;
	if($line =~ m/^>(\S+)/){
		$id = $1;
	}
	else{
	    $seq = $line;
	}
	$db->{$id}=$seq;
}
close IN;

open IN2,$genome_fas or die "ERROR in IN: $!\n";
open (OUT,">$out") or die "Can not open the output_file:$!\n";
my $db2;
my ($id2,$seq2);
while(my $line = <IN2>){
    chomp $line;
	if($line =~ m/^>(\S+)/){
		$id2 = $1;
	}
	else{
	    $seq2 = $line;
	}
	$db2->{$id2}=$seq2;
}
close IN2;

open IN1,$list or die "ERROR in IN: $!\n";
while(my $line = <IN1>){
    chomp $line;
	my @array = split /\s+/,$line;
	$array[0] =~ s/://;

	my $calcu;

	# Ama
	my ($Mgu) = $array[2];
	my ($Ama) = $array[3];

	if(!exists $db->{$Mgu} || !exists $db->{$Ama}){print $Mgu,"or",$Ama,"NOT Exists!\n";}
	my $Mgu_seq = $db->{$Mgu}; $Mgu_seq =~ s/\*//;
	my $Ama_seq = $db->{$Ama}; $Ama_seq =~ s/\*//;

	open (OUT1,">$temp_seq") or die "Can not open the output_file:$!\n";
	print OUT1  ">",$array[0],"_Ama_3M_Left","\n",$Mgu_seq,"\n",">",$array[0],"_Ama_3M_Right","\n",$Ama_seq,"\n";
	close OUT1;

	system("/disk4/wangysh/b.Softwares/muscle -in $temp_seq -out $temp_mus -quiet");

	if(!exists $db2->{$Mgu} || !exists $db2->{$Ama}){print $Mgu,"or",$Ama,"NOT Exists!\n";}
	my $Mgu_seq2 = $db2->{$Mgu};
	my $Ama_seq2 = $db2->{$Ama};

	open (OUT3,">$temp_nus") or die "Can not open the output_file:$!\n";
	print OUT3  ">",$array[0],"_Ama_3M_Left","\n",$Mgu_seq2,"\n",">",$array[0],"_Ama_3M_Right","\n",$Ama_seq2,"\n";
	close OUT3;

	system("perl /home/wangysh/wangysh/b.Softwares/pal2nal.v14/pal2nal.pl $temp_mus $temp_nus -output fasta > $temp_codon");

	local $/ = ">"; 
	open IN2,$temp_codon or die "ERROR in IN: $!\n";
	while(my $line = <IN2>){
		chomp $line;
		if($line =~ m/^$/){next;} 
    	$line =~ s/\s+//g;
    	$line =~ m/(.+_\dM)_(.+t)(.+)/;
		#print $1,"\t",$2,"\t",$3,"\n";
		$calcu->{$1}{$2} = $3;
	}
	close IN2;

	# Rap
	my ($Ptr) = $array[4];
	my ($Rap) = $array[5];

	if(!exists $db->{$Ptr} || !exists $db->{$Rap}){print $Ptr,"or",$Rap,"NOT Exists!\n";}
	my $Ptr_seq = $db->{$Ptr}; $Ptr_seq =~ s/\*//;
	my $Rap_seq = $db->{$Rap}; $Rap_seq =~ s/\*//;

	open (OUT1,">$temp_seq") or die "Can not open the output_file:$!\n";
	print OUT1  ">",$array[0],"_Rap_3M_Left","\n",$Ptr_seq,"\n",">",$array[0],"_Rap_3M_Right","\n",$Rap_seq,"\n";
	close OUT1;

	system("/disk4/wangysh/b.Softwares/muscle -in $temp_seq -out $temp_mus -quiet");

	if(!exists $db2->{$Ptr} || !exists $db2->{$Rap}){print $Ptr,"or",$Rap,"NOT Exists!\n";}
	my $Ptr_seq2 = $db2->{$Ptr};
	my $Rap_seq2 = $db2->{$Rap};

	open (OUT3,">$temp_nus") or die "Can not open the output_file:$!\n";
	print OUT3  ">",$array[0],"_Rap_3M_Left","\n",$Ptr_seq2,"\n",">",$array[0],"_Rap_3M_Right","\n",$Rap_seq2,"\n";
	close OUT3;

	system("perl /home/wangysh/wangysh/b.Softwares/pal2nal.v14/pal2nal.pl $temp_mus $temp_nus -output fasta > $temp_codon");

	local $/ = ">"; 
	open IN2,$temp_codon or die "ERROR in IN: $!\n";
	while(my $line = <IN2>){
		chomp $line;
		if($line =~ m/^$/){next;} 
    	$line =~ s/\s+//g;
    	$line =~ m/(.+_\dM)_(.+t)(.+)/;
		#print $1,"\t",$2,"\t",$3,"\n";
		$calcu->{$1}{$2} = $3;
	}
	close IN2;

	# Sal
	my ($Egr) = $array[6];
	my ($Sal) = $array[7];

	if(!exists $db->{$Egr} || !exists $db->{$Sal}){print $Egr,"or",$Sal,"NOT Exists!\n";}
	my $Egr_seq = $db->{$Egr}; $Egr_seq =~ s/\*//;
	my $Sal_seq = $db->{$Sal}; $Sal_seq =~ s/\*//;

	open (OUT1,">$temp_seq") or die "Can not open the output_file:$!\n";
	print OUT1  ">",$array[0],"_Sal_3M_Left","\n",$Egr_seq,"\n",">",$array[0],"_Sal_3M_Right","\n",$Sal_seq,"\n";
	close OUT1;

	system("/disk4/wangysh/b.Softwares/muscle -in $temp_seq -out $temp_mus -quiet");

	if(!exists $db2->{$Egr} || !exists $db2->{$Sal}){print $Egr,"or",$Sal,"NOT Exists!\n";}
	my $Egr_seq2 = $db2->{$Egr};
	my $Sal_seq2 = $db2->{$Sal};

	open (OUT3,">$temp_nus") or die "Can not open the output_file:$!\n";
	print OUT3  ">",$array[0],"_Sal_3M_Left","\n",$Egr_seq2,"\n",">",$array[0],"_Sal_3M_Right","\n",$Sal_seq2,"\n";
	close OUT3;

	system("perl /home/wangysh/wangysh/b.Softwares/pal2nal.v14/pal2nal.pl $temp_mus $temp_nus -output fasta > $temp_codon");

	local $/ = ">"; 
	open IN2,$temp_codon or die "ERROR in IN: $!\n";
	while(my $line = <IN2>){
		chomp $line;
		if($line =~ m/^$/){next;} 
    	$line =~ s/\s+//g;
    	$line =~ m/(.+_\dM)_(.+t)(.+)/;
		#print $1,"\t",$2,"\t",$3,"\n";
		$calcu->{$1}{$2} = $3;
	}
	close IN2;

	foreach my $name (keys %{$calcu}){
		print OUT $name,"\n",$calcu->{$name}{"Left"},"\n",$calcu->{$name}{"Right"},"\n","\n";
	}
}

close OUT;
