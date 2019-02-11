#!/bin/bash
#
# USAGE: chmod +x Top_PA.sh; ./Top_PA.sh 
#
#==============================================================================
CALC_NUM=1;
FLANC=20;
SKIP="#";
#==============================================================================
if [[ "$CALC_NUM" -eq "1" ]]; then
  for (( x=1 ; x < 814 ; ++x ));
    do
    rm -f EXTRACTED_$x.seq
    cat mx$x.clean.bin.seg | while read line
      do
      if [[ $line == *$SKIP* ]];
        then
        echo "HEADER: $line";
        else
        init_pos=`echo $line | tr ':' '\t' | awk '{ print $1;}'`;
        end_pos=`echo $line | tr ':' '\t' | awk '{ print $2;}'`;
        init_pos_flank=`echo "$init_pos-$FLANC" | bc -l`;
        end_pos_flank=`echo "$end_pos+$FLANC" | bc -l`;
        length=`echo "$end_pos_flank-$init_pos_flank" | bc -l`;
        echo "Extracting region: [$init_pos_flank;$end_pos_flank] with length $length ...";
        ./goose-extract -s $init_pos_flank -l $end_pos_flank < mx$x.clean >> EXTRACTED_$x.seq;
        fi
      done
  done
fi
#=============================================================================#
mkdir -p ADAPTERS
./goose-splitreads < PAS.fa --location=ADAPTERS
#=============================================================================#
rm -f PA_LIST_242; for ((x=1;x<=152;++x)); do echo "Running $x"; printf "%d\t" $x >> PA_LIST_242; ./GeCo -rm 8:1:1:0/0 -r EXTRACTED_242.seq ADAPTERS/out$x.fasta | grep Total | awk '{ print $8;}' >> PA_LIST_242; done
rm -f PA_LIST_403; for ((x=1;x<=152;++x)); do echo "Running $x"; printf "%d\t" $x >> PA_LIST_403; ./GeCo -rm 8:1:1:0/0 -r EXTRACTED_403.seq ADAPTERS/out$x.fasta | grep Total | awk '{ print $8;}' >> PA_LIST_403; done
rm -f PA_LIST_507; for ((x=1;x<=152;++x)); do echo "Running $x"; printf "%d\t" $x >> PA_LIST_507; ./GeCo -rm 8:1:1:0/0 -r EXTRACTED_507.seq ADAPTERS/out$x.fasta | grep Total | awk '{ print $8;}' >> PA_LIST_507; done
sort -k2 -n PA_LIST_242 | head
echo "..."
sort -k2 -n PA_LIST_403 | head
echo "..."
sort -k2 -n PA_LIST_507 | head

