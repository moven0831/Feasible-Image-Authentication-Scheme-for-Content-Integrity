cd circuits/circuits
sed '$d' grayscale.circom > grayscale_benchmark.circom
echo "component main = GrayscaleChecker($1, $2);" >> grayscale_benchmark.circom
circom grayscale_benchmark.circom --r1cs --sym --c --prime vesta --output ../dist/zkSnarkBuild
cd ../dist/zkSnarkBuild/grayscale_benchmark_cpp && make