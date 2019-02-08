#!/bin/bash
#
# USAGE: chmod +x Maple_dir.sh; ./Maple_dir.sh <dir_name> 
#
# <dir_name> will only list -> <file>.fna files (do NOT add the "/" symbol as suffix!)
#
#==============================================================================
GET_GOOSE=1;
GET_CHESTER=1;
GET_GECO2=1;
GET_PRIMERS_ADAPTORS=1;
LIST_SEQS=1;
RUN_GECO=1;
BIN_FILTER=1;
FILTER=1;
PAINT=1;
CALC_NUM=1;
#==============================================================================
LENGTH=0;
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
# GET GECO2
if [[ "$GET_GECO2" -eq "1" ]]; then
  rm -fr geco2*
  git clone https://github.com/pratas/geco2.git
  cd geco2/src/
  cmake .
  make
  cp GeCo2 ../../
  cd ../../
fi
#==============================================================================
# GET PRIMERS ADAPTERS
if [[ "$GET_PRIMERS_ADAPTORS" -eq "1" ]]; then
  rm -f adapters_combined_152_unique.fasta
  wget https://raw.githubusercontent.com/stephenturner/adapters/master/adapters_combined_152_unique.fasta
  mv adapters_combined_152_unique.fasta x.tmp.tsd.fasta
  cut -b2- x.tmp.tsd.fasta > resto.xs;
  cut -b1  x.tmp.tsd.fasta > primeira.xs;
  tr "><" "__" < resto.xs > resto-fil.xs;
  paste -d "" primeira.xs resto-fil.xs > PAS.fa;
  rm -f rest.xs primeira.xs resto-fil.xs;
fi
#==============================================================================
if [[ "$LIST_SEQS" -eq "1" ]]; then
  x=1;
  LENGTH=$x;
  for filename in $1/*.fna;
    do
    cat $filename | ./goose-fasta2seq | ./goose-randseqextrachars > mx$x.clean;
    LENGTH=$x;
    ((x++));
    done
  echo "::"
  echo "RUNNING $LENGTH SEQS...";
  echo "::"
fi
#==============================================================================
# RUN_GECO
if [[ "$RUN_GECO" -eq "1" ]]; then
  for (( x = 1 ; x <= $LENGTH ; ++x ));
    do
    ./GeCo2 -v -e -rm 11:10:1:0:0.95/0:0:0 -rm 13:20:1:0:0.95/0:0:0 -rm 18:500:1:3:0.95/3:50:0.95 -r PAS.fa mx$x.clean;
    done
fi
#==============================================================================
# BINARY FILTER
if [[ "$BIN_FILTER" -eq "1" ]]; then
  for (( x = 1 ; x <= $LENGTH ; ++x ));
    do
    echo "Running $x ... ";
    ./goose-real2binthreshold 1.5 < mx$x.clean.iae | tr -d -c "01" > mx$x.clean.bin
    done
fi
#==============================================================================
# FILTE
if [[ "$FILTER" -eq "1" ]]; then
  #
  rm -f XXX_TMP_NAME_FIL; #UGLY CODE, BUT I'm in a speed quest<- fix after DL.
  rm -f XXX_TMP_NAME_SEG; #UGLY CODE, BUT I'm in a speed quest<- fix after DL.
  for (( x = 1 ; x <= $LENGTH ; ++x ));
  do
  printf "mx%d.clean.bin:" "$x" >> XXX_TMP_NAME_FIL;
  printf "mx%d.clean.bin.seg:" "$x" >> XXX_TMP_NAME_SEG;
  done
  name_filter=`cat XXX_TMP_NAME_FIL | rev | cut -c 2- | rev`;
  name_segmen=`cat XXX_TMP_NAME_SEG | rev | cut -c 2- | rev`;
  #
  ./CHESTER-filter -v -w 10 -u 2 -t 0.5 $name_filter;
fi
#==============================================================================
# PAINT
if [[ "$PAINT" -eq "1" ]]; then
  ./CHESTER-visual -e 100000 $name_segmen;
  mv plot.svg mplot_$1.svg
fi
#=============================================================================#
# CALCULATE NUMBERS
if [[ "$CALC_NUM" -eq "1" ]]; then
  rm -f NUM_MX_PA;
  for (( x=1 ; x <= $LENGTH ; ++x ));
    do
    size=`ls -la mx$x.clean | awk '{ print $5}'`;
    #
    nump1=`wc -l mx$x.clean.bin.seg | awk '{ print $1;}'`;
    numr1=$((--nump1));
    ratior1=`echo "scale=8; ($numr1 / $size * 1000000)" | bc -l | awk '{printf "%f", $0}'`;
    #
    printf "%d\t%s\n" "$x" "$ratior1" >> NUM_MX_PA;
    #
    done
  gnuplot << EOF
    reset
    set terminal pdfcairo enhanced color font 'Verdana,12'
    set output "Numbers_mx_PA.pdf"
    set style line 101 lc rgb '#000000' lt 1 lw 4
    set border 3 front ls 101
    set tics nomirror out scale 0.75
    set format '%g'
    set size ratio 0.2
    set key outside horiz center top
    set yrange [:] 
    set xrange [0:$LENGTH]
    set xtics 1
    set grid 
    set ylabel "Normalized Fragmentation"
    set xlabel "Sequences"
    set border linewidth 1.5
    set style line 1 lc rgb '#0060ad' lt 1 lw 4 pt 5 ps 0.4 # --- blue
    set style line 2 lc rgb '#0060ad' lt 1 lw 4 pt 6 ps 0.4 # --- green
    set style line 3 lc rgb '#dd181f' lt 1 lw 4 pt 7 ps 0.4 # --- ?
    set style line 4 lc rgb '#4d1811' lt 1 lw 4 pt 8 ps 0.4 # --- ?
    set style line 5 lc rgb '#1d121f' lt 1 lw 4 pt 9 ps 0.4 # --- ?
    plot "NUM_MX_PA" using 1:2 with linespoints ls 1
EOF
fi
#=============================================================================#
