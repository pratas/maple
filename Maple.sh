#!/bin/bash
#
# USAGE: chmod +x Maple.sh; ./Maple.sh 
#
#==============================================================================
GET_GOOSE=0;
GET_CHESTER=0;
GET_GECO=0;
GET_PRIMERS_ADAPTORS=1;
DOWNLOAD_SEQS=0;
FILTER_SEQS=1;
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
# GET PRIMERS ADAPTERS
if [[ "$GET_PRIMERS_ADAPTORS" -eq "1" ]]; then
  wget https://raw.githubusercontent.com/pratas/maple/master/primers.fa
  wget https://raw.githubusercontent.com/pratas/maple/master/adaptors.fa
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
# DOWNLOAD SEQUENCES
if [[ "$DOWNLOAD_SEQS" -eq "1" ]]; then
  cp goose/scripts/GetHumanParse.sh .
  chmod +x GetHumanParse.sh;
  ./GetHumanParse.sh
fi
#==============================================================================
# FILTER & RANDOMIZ 'N' IN SEQUENCES
if [[ "$FILTER_SEQS" -eq "1" ]]; then
  for (( x = 1 ; x < 28 ; ++x ));
    do
    echo "Running $x ... ";
    ./goose-fasta2seq < HS$x | ./goose-randseqextrachars > HS$x.clean1;
    cp HS$x.clean1 HS$x.clean2;
    done
fi
#==============================================================================
# RUN_GECO
if [[ "$RUN_GECO" -eq "1" ]]; then
  for (( x = 1 ; x < 28 ; ++x ));
    do
    ./GeCo -v -c 3 -e -rm 9:10:1:0/0 -rm 13:20:1:0/0 -rm 18:500:1:3/50 -r primers.fa HS$x.clean1;
    ./GeCo -v -c 3 -e -rm 9:10:1:0/0 -rm 13:20:1:0/0 -rm 18:500:1:3/50 -r adaptors.fa HS$x.clean2;
    done
fi
#==============================================================================
# BINARY FILTER
if [[ "$BIN_FILTER" -eq "1" ]]; then
  for (( x = 1 ; x < 28 ; ++x ));
    do
    echo "Running $x ... ";
    ./goose-real2binthreshold 1.4 < HS$x.clean1.iae | tr -d -c "01" > HS$x.clean1.bin1
    ./goose-real2binthreshold 1.4 < HS$x.clean1.iae | tr -d -c "01" > HS$x.clean1.bin2
    ./goose-real2binthreshold 1.4 < HS$x.clean1.iae | tr -d -c "01" > HS$x.clean1.bin3
    ./goose-real2binthreshold 1.4 < HS$x.clean1.iae | tr -d -c "01" > HS$x.clean1.bin4
    ./goose-real2binthreshold 1.4 < HS$x.clean1.iae | tr -d -c "01" > HS$x.clean1.bin5
    # 
    ./goose-real2binthreshold 1.4 < HS$x.clean2.iae | tr -d -c "01" > HS$x.clean2.bin1
    ./goose-real2binthreshold 1.4 < HS$x.clean2.iae | tr -d -c "01" > HS$x.clean2.bin2
    ./goose-real2binthreshold 1.4 < HS$x.clean2.iae | tr -d -c "01" > HS$x.clean2.bin3
    ./goose-real2binthreshold 1.4 < HS$x.clean2.iae | tr -d -c "01" > HS$x.clean2.bin4
    ./goose-real2binthreshold 1.4 < HS$x.clean2.iae | tr -d -c "01" > HS$x.clean2.bin5
    done
fi
#==============================================================================
# FILTE
if [[ "$FILTER" -eq "1" ]]; then
  for (( x = 1 ; x < 6 ; ++x ));
    do
    ./CHESTER-filter -v -w 20 -u 5 -t 0.$x HS1.clean1.bin$x:HS2.clean1.bin$x:HS3.clean1.bin$x:HS4.clean1.bin$x:HS5.clean1.bin$x:HS6.clean1.bin$x:HS7.clean1.bin$x:HS8.clean1.bin$x:HS9.clean1.bin$x:HS10.clean1.bin$x:HS11.clean1.bin$x:HS12.clean1.bin$x:HS13.clean1.bin$x:HS14.clean1.bin$x:HS15.clean1.bin$x:HS16.clean1.bin$x:HS17.clean1.bin$x:HS18.clean1.bin$x:HS19.clean1.bin$x:HS20.clean1.bin$x:HS21.clean1.bin$x:HS22.clean1.bin$x:HS23.clean1.bin$x:HS24.clean1.bin$x:HS25.clean1.bin$x:HS26.clean1.bin$x:HS27.clean1.bin$x
    #
    ./CHESTER-filter -v -w 20 -u 5 -t 0.$x HS1.clean2.bin$x:HS2.clean2.bin$x:HS3.clean2.bin$x:HS4.clean2.bin$x:HS5.clean2.bin$x:HS6.clean2.bin$x:HS7.clean2.bin$x:HS8.clean2.bin$x:HS9.clean2.bin$x:HS10.clean2.bin$x:HS11.clean2.bin$x:HS12.clean2.bin$x:HS13.clean2.bin$x:HS14.clean2.bin$x:HS15.clean2.bin$x:HS16.clean2.bin$x:HS17.clean2.bin$x:HS18.clean2.bin$x:HS19.clean2.bin$x:HS20.clean2.bin$x:HS21.clean2.bin$x:HS22.clean2.bin$x:HS23.clean2.bin$x:HS24.clean2.bin$x:HS25.clean2.bin$x:HS26.clean2.bin$x:HS27.clean2.bin$x
    done
fi
#==============================================================================
# PAINT
if [[ "$PAINT" -eq "1" ]]; then
  for (( x = 1 ; x < 6 ; ++x ));
    do
    ./CHESTER-visual -e 50000 HS1.clean1.bin$x.seg:HS2.clean1.bin$x.seg:HS3.clean1.bin$x.seg:HS4.clean1.bin$x.seg:HS5.clean1.bin$x.seg:HS6.clean1.bin$x.seg:HS7.clean1.bin$x.seg:HS8.clean1.bin$x.seg:HS9.clean1.bin$x.seg:HS10.clean1.bin$x.seg:HS11.clean1.bin$x.seg:HS12.clean1.bin$x.seg:HS13.clean1.bin$x.seg:HS14.clean1.bin$x.seg:HS15.clean1.bin$x.seg:HS16.clean1.bin$x.seg:HS17.clean1.bin$x.seg:HS18.clean1.bin$x.seg:HS19.clean1.bin$x.seg:HS20.clean1.bin$x.seg:HS21.clean1.bin$x.seg:HS22.clean1.bin$x.seg:HS23.clean1.bin$x.seg:HS24.clean1.bin$x.seg:HS25.clean1.bin$x.seg:HS26.clean1.bin$x.seg:HS27.clean1.bin$x.seg
    mv plot.svg plot_primers_t0.$x.svg
    #
    ./CHESTER-visual -e 50000 HS1.clean2.bin$x.seg:HS2.clean2.bin$x.seg:HS3.clean2.bin$x.seg:HS4.clean2.bin$x.seg:HS5.clean2.bin$x.seg:HS6.clean2.bin$x.seg:HS7.clean2.bin$x.seg:HS8.clean2.bin$x.seg:HS9.clean2.bin$x.seg:HS10.clean2.bin$x.seg:HS11.clean2.bin$x.seg:HS12.clean2.bin$x.seg:HS13.clean2.bin$x.seg:HS14.clean2.bin$x.seg:HS15.clean2.bin$x.seg:HS16.clean2.bin$x.seg:HS17.clean2.bin$x.seg:HS18.clean2.bin$x.seg:HS19.clean2.bin$x.seg:HS20.clean2.bin$x.seg:HS21.clean2.bin$x.seg:HS22.clean2.bin$x.seg:HS23.clean2.bin$x.seg:HS24.clean2.bin$x.seg:HS25.clean2.bin$x.seg:HS26.clean2.bin$x.seg:HS27.clean2.bin$x.seg
    mv plot.svg plot_adaptors_t0.$x.svg
    done
fi
#=============================================================================#
#                                                                             #
#=============================================================================#
