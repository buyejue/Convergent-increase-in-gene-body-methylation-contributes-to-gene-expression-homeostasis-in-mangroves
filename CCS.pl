#!usr/bin/perl
use warnings;
use strict;

die "Usage: perl program <input> <temp_seq> <temp_mus> <output>",if (@ARGV != 15); # usage infromation
my($genome_faa,$genome_fas,$list,$temp_seq,$temp_mus,$temp_nus,$temp_codon,$Osa_gff3,$Mgu_gff3,$Ama_gff3,$Ptr_gff3,$Rap_gff3,$Egr_gff3,$Sal_gff3,$out) = @ARGV;

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
my $db3;
while(my $line = <IN1>){
    chomp $line;
	my @array = split /\s+/,$line;
	$array[0] =~ s/://;

	my $calcu;

	my $Osa = $array[1];
	my $Mgu = $array[2];
	my $Ama = $array[3];
	my $Ptr = $array[4];
	my $Rap = $array[5];
	my $Egr = $array[6];
	my $Sal = $array[7];

	if(!exists $db->{$Osa} || !exists $db->{$Mgu} || !exists $db->{$Ama} || !exists $db->{$Ptr} || !exists $db->{$Rap} || !exists $db->{$Egr} || !exists $db->{$Sal}){print "amic sequence","\t","NOT Exists!\n";}
	my $Osa_seq = $db->{$Osa}; $Osa_seq =~ s/\*//;
	my $Mgu_seq = $db->{$Mgu}; $Mgu_seq =~ s/\*//;
	my $Ama_seq = $db->{$Ama}; $Ama_seq =~ s/\*//;
	my $Ptr_seq = $db->{$Ptr}; $Ptr_seq =~ s/\*//;
	my $Rap_seq = $db->{$Rap}; $Rap_seq =~ s/\*//;
	my $Egr_seq = $db->{$Egr}; $Egr_seq =~ s/\*//;
	my $Sal_seq = $db->{$Sal}; $Sal_seq =~ s/\*//;

	open (OUT1,">$temp_seq") or die "Can not open the output_file:$!\n";
	print OUT1  ">",$array[0],"_Osa","\n",$Osa_seq,"\n",
				">",$array[0],"_Mgu","\n",$Mgu_seq,"\n",
				">",$array[0],"_Ama","\n",$Ama_seq,"\n",
				">",$array[0],"_Ptr","\n",$Ptr_seq,"\n",
				">",$array[0],"_Rap","\n",$Rap_seq,"\n",
				">",$array[0],"_Egr","\n",$Egr_seq,"\n",
				">",$array[0],"_Sal","\n",$Sal_seq,"\n";
	close OUT1;

	#system("/disk4/wangysh/b.Softwares/muscle -in $temp_seq -out $temp_mus -quiet");
	system("/public1/users/wangysh/51_backup_20180408/b.Softwares/muscle -in $temp_seq -out $temp_mus -quiet");

	if(!exists $db2->{$Osa} || !exists $db2->{$Mgu} || !exists $db2->{$Ama} || !exists $db2->{$Ptr} || !exists $db2->{$Rap} || !exists $db2->{$Egr} || !exists $db2->{$Sal}){print "DNA sequence","\t","NOT Exists!\n";}
	my $Osa_seq2 = $db2->{$Osa};
	my $Mgu_seq2 = $db2->{$Mgu};
	my $Ama_seq2 = $db2->{$Ama};
	my $Ptr_seq2 = $db2->{$Ptr};
	my $Rap_seq2 = $db2->{$Rap};
	my $Egr_seq2 = $db2->{$Egr};
	my $Sal_seq2 = $db2->{$Sal};

	$db3->{$array[0]}->{"Osa"}->{"len"} = length $Osa_seq2;
	$db3->{$array[0]}->{"Mgu"}->{"len"} = length $Mgu_seq2;
	$db3->{$array[0]}->{"Ama"}->{"len"} = length $Ama_seq2;
	$db3->{$array[0]}->{"Ptr"}->{"len"} = length $Ptr_seq2;
	$db3->{$array[0]}->{"Rap"}->{"len"} = length $Rap_seq2;
	$db3->{$array[0]}->{"Egr"}->{"len"} = length $Egr_seq2;
	$db3->{$array[0]}->{"Sal"}->{"len"} = length $Sal_seq2;

	$array[1] =~ s/\w\w\w\|//;
	$array[2] =~ s/\w\w\w\|//;
	$array[3] =~ s/\w\w\w\|//;
	$array[4] =~ s/\w\w\w\|//;
	$array[5] =~ s/\w\w\w\|//;
	$array[6] =~ s/\w\w\w\|//;
	$array[7] =~ s/\w\w\w\|//;

	$db3->{$array[0]}->{"Osa"}->{"name"} = $array[1];
	$db3->{$array[0]}->{"Mgu"}->{"name"} = $array[2];
	$db3->{$array[0]}->{"Ama"}->{"name"} = $array[3];
	$db3->{$array[0]}->{"Ptr"}->{"name"} = $array[4];
	$db3->{$array[0]}->{"Rap"}->{"name"} = $array[5];
	$db3->{$array[0]}->{"Egr"}->{"name"} = $array[6];
	$db3->{$array[0]}->{"Sal"}->{"name"} = $array[7];

	open (OUT3,">$temp_nus") or die "Can not open the output_file:$!\n";
	print OUT3  ">",$array[0],"_Osa","\n",$Osa_seq2,"\n",
				">",$array[0],"_Mgu","\n",$Mgu_seq2,"\n",
				">",$array[0],"_Ama","\n",$Ama_seq2,"\n",
				">",$array[0],"_Ptr","\n",$Ptr_seq2,"\n",
				">",$array[0],"_Rap","\n",$Rap_seq2,"\n",
				">",$array[0],"_Egr","\n",$Egr_seq2,"\n",
				">",$array[0],"_Sal","\n",$Sal_seq2,"\n";
	close OUT3;

	#system("perl /home/wangysh/wangysh/b.Softwares/pal2nal.v14/pal2nal.pl $temp_mus $temp_nus -output fasta > $temp_codon");
	system("perl /public1/users/wangysh/Mangrove_gbM/Bismark_Analysis/CCS/pal2nal.pl $temp_mus $temp_nus -output fasta > $temp_codon");

	local $/ = ">"; 
	open IN2,$temp_codon or die "ERROR in IN: $!\n";
	while(my $line = <IN2>){
		chomp $line;
		if($line =~ m/^$/){next;} 
    	$line =~ s/\s+//g;
    	$line =~ m/(.+)_(\w\w\w)(.+)/;
		#print $1,"\t",$2,"\t",$3,"\n";
		$calcu->{$1}{$2} = $3;
	}
	close IN2;
	local $/ = "\n"; 

	foreach my $name (keys %{$calcu}){
		my $CCS_Osa = $calcu->{$name}{"Osa"};
		my $CCS_Mgu = $calcu->{$name}{"Mgu"};
		my $CCS_Ama = $calcu->{$name}{"Ama"};
		my $CCS_Ptr = $calcu->{$name}{"Ptr"};
		my $CCS_Rap = $calcu->{$name}{"Rap"};
		my $CCS_Egr = $calcu->{$name}{"Egr"};
		my $CCS_Sal = $calcu->{$name}{"Sal"};

		for my $i (0..length($CCS_Osa)-1){
			my $base1 = substr($CCS_Osa, $i, 2);
			my $base2 = substr($CCS_Mgu, $i, 2);
			my $base3 = substr($CCS_Ama, $i, 2);
			my $base4 = substr($CCS_Ptr, $i, 2);
			my $base5 = substr($CCS_Rap, $i, 2);
			my $base6 = substr($CCS_Egr, $i, 2);
			my $base7 = substr($CCS_Sal, $i, 2);

			if($base1 eq $base2 && $base2 eq $base3 && $base3 eq $base4 && $base4 eq $base5 && $base5 eq $base6 && $base6 eq $base7 && $base7 eq "CG"){
			#if(($base1 eq $base2 && $base2 eq $base4 && $base4 eq $base6 && $base6 ne "CG") && (($base3 eq $base5 && $base5 eq $base7 && $base7 eq "CG") || ($base3 eq $base5 && $base5 eq "CG" && $base7 eq $base1) || ($base3 eq $base7 && $base7 eq "CG" && $base5 eq $base1) || ($base5 eq $base7 && $base7 eq "CG" && $base3 eq $base1))){

				my $seq1 = substr($CCS_Osa, 0, $i);
				my $seq2 = substr($CCS_Mgu, 0, $i);
				my $seq3 = substr($CCS_Ama, 0, $i);
				my $seq4 = substr($CCS_Ptr, 0, $i);
				my $seq5 = substr($CCS_Rap, 0, $i);
				my $seq6 = substr($CCS_Egr, 0, $i);
				my $seq7 = substr($CCS_Sal, 0, $i);

				$seq1 =~ s/-//g;
				$seq2 =~ s/-//g;
				$seq3 =~ s/-//g;
				$seq4 =~ s/-//g;
				$seq5 =~ s/-//g;
				$seq6 =~ s/-//g;
				$seq7 =~ s/-//g;

				my $site1 = length $seq1;
				my $site2 = length $seq2;
				my $site3 = length $seq3;
				my $site4 = length $seq4;
				my $site5 = length $seq5;
				my $site6 = length $seq6;
				my $site7 = length $seq7;

				print $name,"\t",$site1,"\t",$site2,"\t",$site3,"\t",$site4,"\t",$site5,"\t",$site6,"\t",$site7,"\n";

				my $len1 = $db3->{$name}->{"Osa"}->{"len"};
				my $len2 = $db3->{$name}->{"Mgu"}->{"len"};
				my $len3 = $db3->{$name}->{"Ama"}->{"len"};
				my $len4 = $db3->{$name}->{"Ptr"}->{"len"};
				my $len5 = $db3->{$name}->{"Rap"}->{"len"};
				my $len6 = $db3->{$name}->{"Egr"}->{"len"};
				my $len7 = $db3->{$name}->{"Sal"}->{"len"};

				my $gene1 = $db3->{$name}->{"Osa"}->{"name"};
				my $gene2 = $db3->{$name}->{"Mgu"}->{"name"};
				my $gene3 = $db3->{$name}->{"Ama"}->{"name"};
				my $gene4 = $db3->{$name}->{"Ptr"}->{"name"};
				my $gene5 = $db3->{$name}->{"Rap"}->{"name"};
				my $gene6 = $db3->{$name}->{"Egr"}->{"name"};
				my $gene7 = $db3->{$name}->{"Sal"}->{"name"};

				# Osa
				open OSA,$Osa_gff3 or die "ERROR in IN: $!\n";
				my $flag1 = "";
				my $flag11 = 0;
				my $step1 = 0;
				my $site1_true;
				#print $step1,"\n";
				while(my $line1 = <OSA>){
					chomp $line1;
					if($line1 =~ m/^$/){next;}
					if($line1 =~ m/^\#/){next;}
					my @array1 = split /\s+/,$line1;
					if($array1[2] eq "mRNA"){
						$array1[8] =~ m/.+Name=(.+);pacid.+/;
						$flag1 = $1;
					}
					if($array1[2] eq "CDS"){
						if($flag1 eq $gene1 && $flag11 == 0){
							if($array1[6] eq "+"){
								my $start = $array1[3];
								my $end = $array1[4];
								if(($end - $start + 1 + $step1) < $site1){
									$step1 += $end - $start + 1;
								}
								else{
									$site1_true = $start + ($site1 - $step1 - 1) + 1;
									$site1_true = $array1[0]."_".$array1[6]."_".$site1_true;
									$flag11 = 1;
								}
							}
							else{
								my $start = $array1[3];
								my $end = $array1[4];
								if(($end - $start + 1 + $step1) < $site1){
									$step1 += $end - $start + 1;
								}
								else{
									$site1_true = $end - ($site1 - $step1 + 1) + 1;
									$site1_true = $array1[0]."_".$array1[6]."_".$site1_true;
									$flag11 = 1;
								}
							}
						}
					}
				}
				close OSA;

				# Mgu
				open MGU,$Mgu_gff3 or die "ERROR in IN: $!\n";
				my $flag2 = "";
				my $flag22 = 0;
				my $step2 = 0;
				my $site2_true;
				while(my $line2 = <MGU>){
					chomp $line2;
					if($line2 =~ m/^$/){next;}
					if($line2 =~ m/^\#/){next;}
					my @array2 = split /\s+/,$line2;
					if($array2[2] eq "mRNA"){
						$array2[8] =~ m/.+Name=(.+);pacid.+/;
						$flag2 = $1;
					}
					if($array2[2] eq "CDS"){
						if($flag2 eq $gene2 && $flag22 == 0){
							if($array2[6] eq "+"){
								my $start = $array2[3];
								my $end = $array2[4];
								if(($end - $start + 1 + $step2) < $site2){
									$step2 += $end - $start + 1;
								}
								else{
									$site2_true = $start + ($site2 - $step2 - 1) + 1;
									$site2_true = $array2[0]."_".$array2[6]."_".$site2_true;
									$flag22 = 1;
								}
							}
							else{
								my $start = $array2[3];
								my $end = $array2[4];
								if(($end - $start + 1 + $step2) < $site2){
									$step2 += $end - $start + 1;
								}
								else{
									$site2_true = $end - ($site2 - $step2 + 1) + 1;
									$site2_true = $array2[0]."_".$array2[6]."_".$site2_true;
									$flag22 = 1;
								}
							}
						}
					}
				}
				close MGU;
	
				# Ama
				open AMA,$Ama_gff3 or die "ERROR in IN: $!\n";
				my $flag3 = "";
				my $flag33 = 0;
				my $step3 = 0;
				my $site3_true;
				while(my $line3 = <AMA>){
					chomp $line3;
					if($line3 =~ m/^$/){next;}
					if($line3 =~ m/^\#/){next;}
					my @array3 = split /\s+/,$line3;
					if($array3[2] eq "mRNA"){
						$array3[8] =~ m/ID=(.+);Parent.+/;
						$flag3 = $1;
					}
					if($array3[2] eq "CDS"){
						if($flag3 eq $gene3 && $flag33 == 0){
							if($array3[6] eq "+"){
								my $start = $array3[3];
								my $end = $array3[4];
								if(($end - $start + 1 + $step3) < $site3){
									$step3 += $end - $start + 1;
								}
								else{
									$site3_true = $start + ($site3 - $step3 - 1) + 1;
									$site3_true = $array3[0]."_".$array3[6]."_".$site3_true;
									$flag33 = 1;
								}
							}
							else{
								my $start = $array3[3];
								my $end = $array3[4];
								if(($end - $start + 1 + $step3) < $site3){
									$step3 += $end - $start + 1;
								}
								else{
									$site3_true = $end - ($site3 - $step3 + 1) + 1;
									$site3_true = $array3[0]."_".$array3[6]."_".$site3_true;
									$flag33 = 1;
								}
							}
						}
					}
				}
				close AMA;

				# Ptr
				open PTR,$Ptr_gff3 or die "ERROR in IN: $!\n";
				my $flag4 = "";
				my $flag44 = 0;
				my $step4 = 0;
				my $site4_true;
				while(my $line4 = <PTR>){
					chomp $line4;
					if($line4 =~ m/^$/){next;}
					if($line4 =~ m/^\#/){next;}
					my @array4 = split /\s+/,$line4;
					if($array4[2] eq "mRNA"){
						$array4[8] =~ m/.+Name=(.+);pacid.+/;
						$flag4 = $1;
					}
					if($array4[2] eq "CDS"){
						if($flag4 eq $gene4 && $flag44 == 0){
							if($array4[6] eq "+"){
								my $start = $array4[3];
								my $end = $array4[4];
								if(($end - $start + 1 + $step4) < $site4){
									$step4 += $end - $start + 1;
								}
								else{
									$site4_true = $start + ($site4 - $step4 - 1) + 1;
									$site4_true = $array4[0]."_".$array4[6]."_".$site4_true;
									$flag44 = 1;
								}
							}
							else{
								my $start = $array4[3];
								my $end = $array4[4];
								if(($end - $start + 1 + $step4) < $site4){
									$step4 += $end - $start + 1;
								}
								else{
									$site4_true = $end - ($site4 - $step4 + 1) + 1;
									$site4_true = $array4[0]."_".$array4[6]."_".$site4_true;
									$flag44 = 1;
								}
							}
						}
					}
				}
				close PTR;

				# Rap
				open RAP,$Rap_gff3 or die "ERROR in IN: $!\n";
				my $flag5 = "";
				my $flag55 = 0;
				my $step5 = 0;
				my $site5_true;
				while(my $line5 = <RAP>){
					chomp $line5;
					if($line5 =~ m/^$/){next;}
					if($line5 =~ m/^\#/){next;}
					my @array5 = split /\s+/,$line5;
					if($array5[2] eq "mRNA"){
						$array5[8] =~ m/ID=(.+);Parent.+/;
						$flag5 = $1;
					}
					if($array5[2] eq "CDS"){
						if($flag5 eq $gene5 && $flag55 == 0){
							if($array5[6] eq "+"){
								my $start = $array5[3];
								my $end = $array5[4];
								if(($end - $start + 1 + $step5) < $site5){
									$step5 += $end - $start + 1;
								}
								else{
									$site5_true = $start + ($site5 - $step5 - 1) + 1;
									$site5_true = $array5[0]."_".$array5[6]."_".$site5_true;
									$flag55 = 1;
								}
							}
							else{
								my $start = $array5[3];
								my $end = $array5[4];
								if(($end - $start + 1 + $step5) < $site5){
									$step5 += $end - $start + 1;
								}
								else{
									$site5_true = $end - ($site5 - $step5 + 1) + 1;
									$site5_true = $array5[0]."_".$array5[6]."_".$site5_true;
									$flag55 = 1;
								}
							}
						}
					}
				}
				close RAP;

				# Egr
				open EGR,$Egr_gff3 or die "ERROR in IN: $!\n";
				my $flag6 = "";
				my $flag66 = 0;
				my $step6 = 0;
				my $site6_true;
				while(my $line6 = <EGR>){
					chomp $line6;
					if($line6 =~ m/^$/){next;}
					if($line6 =~ m/^\#/){next;}
					my @array6 = split /\s+/,$line6;
					if($array6[2] eq "mRNA"){
						$array6[8] =~ m/.+Name=(.+);pacid.+/;
						$flag6 = $1;
					}
					if($array6[2] eq "CDS"){
						if($flag6 eq $gene6 && $flag66 == 0){
							if($array6[6] eq "+"){
								my $start = $array6[3];
								my $end = $array6[4];
								if(($end - $start + 1 + $step6) < $site6){
									$step6 += $end - $start + 1;
								}
								else{
									$site6_true = $start + ($site6 - $step6 - 1) + 1;
									$site6_true = $array6[0]."_".$array6[6]."_".$site6_true;
									$flag66 = 1;
								}
							}
							else{
								my $start = $array6[3];
								my $end = $array6[4];
								if(($end - $start + 1 + $step6) < $site6){
									$step6 += $end - $start + 1;
								}
								else{
									$site6_true = $end - ($site6 - $step6 + 1) + 1;
									$site6_true = $array6[0]."_".$array6[6]."_".$site6_true;
									$flag66 = 1;
								}
							}
						}
					}
				}
				close EGR;

				# Sal
				open SAL,$Sal_gff3 or die "ERROR in IN: $!\n";
				my $flag7 = "";
				my $flag77 = 0;
				my $step7 = 0;
				my $site7_true;
				while(my $line7 = <SAL>){
					chomp $line7;
					if($line7 =~ m/^$/){next;}
					if($line7 =~ m/^\#/){next;}
					my @array7 = split /\s+/,$line7;
					if($array7[2] eq "mRNA"){
						$array7[8] =~ m/ID=(.+);Parent.+/;
						$flag7 = $1;
					}
					if($array7[2] eq "CDS"){
						if($flag7 eq $gene7 && $flag77 == 0){
							if($array7[6] eq "+"){
								my $start = $array7[3];
								my $end = $array7[4];
								if(($end - $start + 1 + $step7) < $site7){
									$step7 += $end - $start + 1;
								}
								else{
									$site7_true = $start + ($site7 - $step7 - 1) + 1;
									$site7_true = $array7[0]."_".$array7[6]."_".$site7_true;
									$flag77 = 1;
								}
							}
							else{
								my $start = $array7[3];
								my $end = $array7[4];
								if(($end - $start + 1 + $step7) < $site7){
									$step7 += $end - $start + 1;
								}
								else{
									$site7_true = $end - ($site7 - $step7 + 1) + 1;
									$site7_true = $array7[0]."_".$array7[6]."_".$site7_true;
									$flag77 = 1;
								}
							}
						}
					}
				}
				close SAL;	

				print OUT $name,"\t",$site1_true,"\t",$site2_true,"\t",$site3_true,"\t",$site4_true,"\t",$site5_true,"\t",$site6_true,"\t",$site7_true,"\n";
			}
		}
	}
}

close OUT;