#!/bin/bash
#
# USAGE: chmod +x Synthetic.sh; ./Synthetic.sh 
#
#==============================================================================
GET_GOOSE=0;
GET_CHESTER=0;
GET_GECO=0;
GENERATE_SEQS=1;
RUN_GECO=1;
BIN_FILTER=1;
FILTER=1;
PAINT=1;
#==============================================================================
# GET GOOSE
if [[ "$GET_GOOSE" -eq "1" ]]; then
  rm -fr goose*
  git clone https://github.com/pratas/goose.git
  cd goose/src/
  make
  cp goose-* ../../
  cd ../../
fi
#==============================================================================
# GET CHESTER
if [[ "$GET_CHESTER" -eq "1" ]]; then
  rm -fr chester*
  git clone https://github.com/pratas/chester.git
  cd chester/src/
  cmake .
  make
  cp CHESTER-filter ../../
  cp CHESTER-visual ../../
  cd ../../
fi
#==============================================================================
# GET GECO
if [[ "$GET_GECO" -eq "1" ]]; then
  rm -fr geco*
  git clone https://github.com/pratas/geco.git
  cd geco/src/
  cmake .
  make
  cp GeCo ../../
  cd ../../
fi
#==============================================================================
# GENERATE SEQUENCES
if [[ "$GENERATE_SEQS" -eq "1" ]]; then
  ./goose-genrandomdna -s 1   -n 60 | ./goose-seq2fasta -n A1 > A1.fa ; echo "" >> A1.fa;
  ./goose-genrandomdna -s 11  -n 50 | ./goose-seq2fasta -n A2 > A2.fa ; echo "" >> A2.fa;
  ./goose-genrandomdna -s 35  -n 70 | ./goose-seq2fasta -n A3 > A3.fa ; echo "" >> A3.fa;
  ./goose-genrandomdna -s 51  -n 80 | ./goose-seq2fasta -n A4 > A4.fa ; echo "" >> A4.fa;
  ./goose-genrandomdna -s 73  -n 60 | ./goose-seq2fasta -n A5 > A5.fa ; echo "" >> A5.fa;
  ./goose-genrandomdna -s 87  -n 70 | ./goose-seq2fasta -n A6 > A6.fa ; echo "" >> A6.fa;
  ./goose-genrandomdna -s 91  -n 60 | ./goose-seq2fasta -n A7 > A7.fa ; echo "" >> A7.fa;
  ./goose-genrandomdna -s 117 -n 90 | ./goose-seq2fasta -n A8 > A8.fa ; echo "" >> A8.fa;
  cat A1.fa A2.fa A3.fa A4.fa A5.fa A6.fa A7.fa A8.fa > SYNTHETIC_PRIMERS.fa
  rm -f SYNTHETIC_SAMPLE.fa
  for (( x = 1 ; x < 1000 ; ++x ));
    do
    I_FILE=`echo $((1 + RANDOM % 8))`;
    cat A$I_FILE.fa >> SYNTHETIC_SAMLE.fa ;
    ./goose-fasta2seq < SYNTHETIC_SAMLE.fa > SYNTHETIC_SAMLE.seq
    done
  #
  for (( x = 1 ; x <= 50 ; ++x ));
    do
    MRATE=`echo "scale=3;$x/100" | bc -l`;
    ./goose-mutatedna  -mr $MRATE -s 101 < SYNTHETIC_SAMLE.seq > SYNTHETIC_SAMLE_$x.seq
    done
fi
#==============================================================================
# RUN_GECO
if [[ "$RUN_GECO" -eq "1" ]]; then
  for (( x = 1 ; x <= 50 ; ++x ));
    do
    ./GeCo -v -c 3 -e -rm 9:10:1:0/0 -rm 13:20:1:0/0 -rm 18:500:1:3/50 -r SYNTHETIC_PRIMERS.fa SYNTHETIC_SAMLE_$x.seq
    done
fi
#==============================================================================
# BINARY FILTER
if [[ "$BIN_FILTER" -eq "1" ]]; then
  for (( x = 1 ; x <= 50 ; ++x ));
    do
    echo "Running $x ... ";
    ./goose-real2binthreshold 1.4 < SYNTHETIC_SAMLE_$x.seq.iae | tr -d -c "01" > S$x.b
    done
fi
#==============================================================================
# FILTE
if [[ "$FILTER" -eq "1" ]]; then
  ./CHESTER-filter -v -w 20 -u 5 -t 0.4 S1.b:S2.b:S3.b:S4.b:S5.b:S6.b:S7.b:S8.b:S9.b:S10.b:S11.b:S12.b:S13.b:S14.b:S15.b:S16.b:S17.b:S18.b:S19.b:S20.b:S21.b:S22.b:S23.b:S24.b:S25.b:S26.b:S27.b:S28.b:S29.b:S30.b:S31.b:S32.b:S33.b:S34.b:S35.b:S36.b:S37.b:S38.b:S39.b:S40.b:S41.b:S42.b:S43.b:S44.b:S45.b:S46.b:S47.b:S48.b:S49.b:S50.b
fi
#==============================================================================
# PAINT
if [[ "$PAINT" -eq "1" ]]; then
  ./CHESTER-visual -e 50000 S1.b.seg:S2.b.seg:S3.b.seg:S4.b.seg:S5.b.seg:S6.b.seg:S7.b.seg:S8.b.seg:S9.b.seg:S10.b.seg:S11.b.seg:S12.b.seg:S13.b.seg:S14.b.seg:S15.b.seg:S16.b.seg:S17.b.seg:S18.b.seg:S19.b.seg:S20.b.seg:S21.b.seg:S22.b.seg:S23.b.seg:S24.b.seg:S25.b.seg:S26.b.seg:S27.b.seg:S28.b.seg:S29.b.seg:S30.b.seg:S31.b.seg:S32.b.seg:S33.b.seg:S34.b.seg:S35.b.seg:S36.b.seg:S37.b.seg:S38.b.seg:S39.b.seg:S40.b.seg:S41.b.seg:S42.b.seg:S43.b.seg:S44.b.seg:S45.b.seg:S46.b.seg:S47.b.seg:S48.b.seg:S49.b.seg:S50.b.seg
  mv plot.svg plot_synthetic.svg
fi
#=============================================================================#
#                                                                             #
#=============================================================================#
~                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
~                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
~                                                                                           
