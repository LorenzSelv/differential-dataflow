
temp_dir=$(mktemp -d)

cat experiments-sf10-filtered.txt | awk '$3 == 1000000 && $4 == 1' | cut -f 1,5 > $temp_dir/w1
join $temp_dir/w1 $temp_dir/w1 | awk '{ print $1,$3/$2 }' > $temp_dir/ow1
cat experiments-sf10-filtered.txt | awk '$3 == 1000000 && $4 == 2' | cut -f 1,5 > $temp_dir/tw2
join $temp_dir/w1 $temp_dir/tw2 | awk '{ print $1,$3/$2 }' > $temp_dir/w2
cat experiments-sf10-filtered.txt | awk '$3 == 1000000 && $4 == 4' | cut -f 1,5 > $temp_dir/tw4
join $temp_dir/w1 $temp_dir/tw4 | awk '{ print $1,$3/$2 }' > $temp_dir/w4
cat experiments-sf10-filtered.txt | awk '$3 == 1000000 && $4 == 8' | cut -f 1,5 > $temp_dir/tw8
join $temp_dir/w1 $temp_dir/tw8 | awk '{ print $1,$3/$2 }' > $temp_dir/w8
cat experiments-sf10-filtered.txt | awk '$3 == 1000000 && $4 == 16' | cut -f 1,5 > $temp_dir/tw16
join $temp_dir/w1 $temp_dir/tw16 | awk '{ print $1,$3/$2 }' > $temp_dir/w16
cat experiments-sf10-filtered.txt | awk '$3 == 1000000 && $4 == 32' | cut -f 1,5 > $temp_dir/tw32
join $temp_dir/w1 $temp_dir/tw32 | awk '{ print $1,$3/$2 }' > $temp_dir/w32

gnuplot -p -e "\
  set terminal pdf size 6cm,4cm;
   set logscale y;
   set rmargin at screen 0.9;
   set bmargin at screen 0.2;
   set xtics 2,4,22;
   set xlabel \"query\";
   set xrange [0:23];
   set yrange [1:60];
   set ylabel \"relative throughput\";
   set key left top Left reverse font \",10\";
   plot \
   \"$temp_dir/w32\" using 1:2 with lines lt 7 title \"w=32\", \
   \"$temp_dir/w16\" using 1:2 with lines lt 6 title \"w=16\", \
   \"$temp_dir/w8\" using 1:2  with lines lt 5 title \"w=8\", \
   \"$temp_dir/w4\" using 1:2  with lines lt 4 title \"w=4\", \
   \"$temp_dir/w2\" using 1:2  with lines lt 3 title \"w=2\"
   " > plots/tpch_3.pdf # $ $temp_dir/w2 using 1:2:xtic(1) with lines title \"w=2\", $temp_dir/w4 using 1:2:xtic(1) with lines title \"w=4\", $temp_dir/w8 using 1:2:xtic(1) with lines title \"w=8\", $temp_dir/w16 using 1:2:xtic(1) with lines title \"w=16\", $temp_dir/w32 using 1:2:xtic(1) with lines title \"w=32\", " > plots/tpch_3.pdf

rm -R $temp_dir
