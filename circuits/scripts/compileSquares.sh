cd circuits/circuits
head -n -1 squares.circom > squares_benchmark.circom
echo "component main = Bright($1);" >> squares_benchmark.circom
circom squares_benchmark.circom --r1cs --sym --c --prime vesta --output ../dist/zkSnarkBuild
cd ../dist/zkSnarkBuild/squares_benchmark_cpp && make