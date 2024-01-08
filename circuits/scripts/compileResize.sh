cd circuits/circuits
sed '$d' resize.circom > resize_benchmark.circom
echo "component main = Resize($1, $2, $3, $4);" >> resize_benchmark.circom
circom resize_benchmark.circom --r1cs --sym --c --prime vesta --output ../dist/zkSnarkBuild
cd ../dist/zkSnarkBuild/resize_benchmark_cpp && make