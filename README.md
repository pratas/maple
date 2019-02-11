<p align="center"><img src="imgs/maple.png"
alt="MAPLE" height="264" border="0" /><br><br>
<b>MAPLE</b>: mapping and visualization of similar primer and adapter sequences</p>
<br>

## Install
<pre>
git clone https://github.com/pratas/maple.git
cd maple/
chmod +x *.sh
</pre>

## Run
Run synthetic:
<pre>
./Synthetic.sh
</pre>

Run directory:
<pre>
mkdir data_dir
cd data_dir/
</pre>
Then, download or copy to this folder any fasta sequence with .fna extension. Finally, run
<pre>
cd ..
./Maple_dir.sh data_dir
</pre>
To find which of the adapters have higher similarity, run:
<pre>
./Top_PA.sh
</pre>

## Cite
Please cite the followings, if you use maple:
Submitted...

## Release
[Release](https://github.com/pratas/maple/releases) 1.

## Issues
Please let us know if there is any
[issues](https://github.com/pratas/maple/issues).

## License
Maple is under GPL v3 license. For more information, click [here](http://www.gnu.org/licenses/gpl-3.0.html).

