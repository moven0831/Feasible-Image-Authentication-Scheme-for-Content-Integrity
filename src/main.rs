use std::{collections::HashMap, env::current_dir, time::Instant};

use nova_scotia::{
    circom::reader::load_r1cs, create_public_params, create_recursive_circuit, FileLocation, F, S,
};
use nova_snark::{
    provider,
    traits::{circuit::StepCircuit, Group},
    CompressedSNARK, PublicParams,
};

use pasta_curves::Fq;
use serde_json::{json, Value};
use image::GenericImageView;


fn run_test(circuit_filepath: String, witness_gen_filepath: String) {
    type G1 = pasta_curves::pallas::Point;
    type G2 = pasta_curves::vesta::Point;

    println!(
        "Running test with witness generator: {} and group: {}",
        witness_gen_filepath,
        std::any::type_name::<G1>()
    );
    let root = current_dir().unwrap();
    let circuit_file = root.join(circuit_filepath);
    let r1cs = load_r1cs::<G1, G2>(&FileLocation::PathBuf(circuit_file));
    let witness_generator_file = root.join(witness_gen_filepath);

    // since we don't have public inputs, we use a foo value
    let start_public_input = [F::<G1>::from(0)];

    // load cropped image as private input
    let image_name = "c2pa_tiny";
    let cropped_image_path = format!("src/bin/assets/{}_cropped.jpg", image_name);
    let cropped_image = image::open(cropped_image_path).unwrap();
    
    // load original image as private input
    let mut private_inputs: Vec<HashMap<String, Value>> = Vec::new();
    let image_path = format!("src/bin/assets/{}.jpg", image_name);
    let orig_image = image::open(image_path).unwrap();
    
    // create private inputs as (r, g, b) for each pixel in original image
    println!("Loading original image as private input...");
    let mut orig_input: HashMap<String, Value> = HashMap::new();
    orig_input.insert(
        "orig_img".to_string(),
        json!(
            orig_image.pixels().map(|p| {
                vec![p.2[0], p.2[1], p.2[2]]
            }).collect::<Vec<_>>()
        )
    );
    private_inputs.push(orig_input);

    // create private inputs as (r, g, b) for each pixel in cropped image
    println!("Loading cropped image as private input...");
    let mut cropped_input: HashMap<String, Value> = HashMap::new();
    cropped_input.insert(
        "new_img".to_string(),
        json!(
            cropped_image.pixels().map(|p| {
                vec![p.2[0], p.2[1], p.2[2]]
            }).collect::<Vec<_>>()
        )
    );
    private_inputs.push(cropped_input);

    // Create CRS
    // TODO: This process takes took long and being killed by OS
    println!("Creating a CRS...");
    // print some basic stats about the circuit
    println!("Number of constraints: {}", r1cs.constraints.len());
    println!("Number of aux: {}", r1cs.num_aux);
    println!("Number of inputs: {}", r1cs.num_inputs);
    println!("Number of variables: {}", r1cs.num_variables);
    
    let pp = create_public_params::<G1, G2>(r1cs.clone());
    
    println!(
        "Number of constraints per step (primary circuit): {}",
        pp.num_constraints().0
    );
    println!(
        "Number of constraints per step (secondary circuit): {}",
        pp.num_constraints().1
    );
    
    println!(
        "Number of variables per step (primary circuit): {}",
        pp.num_variables().0
    );
    println!(
        "Number of variables per step (secondary circuit): {}",
        pp.num_variables().1
    );
    
    // From Cpp file, encounter stdout: stderr: Signal not found
    // uint Circom_CalcWit::getInputSignalHashPosition(u64): Assertion `false' failed.
    println!("Creating a RecursiveSNARK...");
    let start = Instant::now();
    let recursive_snark = create_recursive_circuit(
        FileLocation::PathBuf(witness_generator_file),
        r1cs,
        private_inputs,
        start_public_input.to_vec(),
        &pp,
    )
    .unwrap();
println!("RecursiveSNARK creation took {:?}", start.elapsed());

// TODO: empty?
let z0_secondary = [F::<G2>::from(0)];

// verify the recursive SNARK
println!("Verifying a RecursiveSNARK...");
let iteration_count = 1;
let start = Instant::now();
let res = recursive_snark.verify(&pp, iteration_count, &start_public_input, &z0_secondary);
println!(
        "RecursiveSNARK::verify: {:?}, took {:?}",
        res,
        start.elapsed()
    );
    assert!(res.is_ok());
    
    // produce a compressed SNARK
    println!("Generating a CompressedSNARK using Spartan with IPA-PC...");
    let start = Instant::now();
    
    let (pk, vk) = CompressedSNARK::<_, _, _, _, S<G1>, S<G2>>::setup(&pp).unwrap();
    let res = CompressedSNARK::<_, _, _, _, S<G1>, S<G2>>::prove(&pp, &pk, &recursive_snark);
    println!(
        "CompressedSNARK::prove: {:?}, took {:?}",
        res.is_ok(),
        start.elapsed()
    );
    assert!(res.is_ok());
    let compressed_snark = res.unwrap();
    
    // verify the compressed SNARK
    println!("Verifying a CompressedSNARK...");
    let start = Instant::now();
    let res = compressed_snark.verify(
        &vk,
        iteration_count,
        start_public_input.to_vec(),
        z0_secondary.to_vec(),
    );
    println!(
        "CompressedSNARK::verify: {:?}, took {:?}",
        res.is_ok(),
        start.elapsed()
    );
    assert!(res.is_ok());
    /*
    */
}

fn main() {
    let circuit_name = "crop_benchmark";
    
    let circuit_filepath = format!("circuits/dist/zkSnarkBuild/{}.r1cs", circuit_name);
    let witness_gen_filepath = format!("circuits/dist/zkSnarkBuild/{0}_cpp/{0}", circuit_name);
    
    run_test(circuit_filepath.clone(), witness_gen_filepath);
}