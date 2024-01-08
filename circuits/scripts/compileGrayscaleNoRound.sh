cd circuits/circuits
sed '$d' grayscale_no_round.circom > grayscale_no_round_benchmark.circom
echo "component main = GrayscaleChecker($1, $2);" >> grayscale_no_round_benchmark.circom
circom grayscale_no_round_benchmark.circom --r1cs --sym --c --prime vesta --output ../dist/zkSnarkBuild
cd ../dist/zkSnarkBuild/grayscale_no_round_benchmark_cpp && make