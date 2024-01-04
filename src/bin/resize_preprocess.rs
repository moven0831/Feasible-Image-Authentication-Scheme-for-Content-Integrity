use image::{GenericImageView, imageops};

fn main() {
    let image_name = "c2pa_mini";
    let image_path = format!("src/bin/assets/{}.jpg", image_name);
    let mut img = image::open(image_path).unwrap();

    let resize_width = 100;
    let resize_height = 100;

    let resized_image = imageops::resize(&mut img, resize_width, resize_height, imageops::FilterType::Nearest);

    assert!(resized_image.dimensions() == (resize_width, resize_height));

    // Save the image as “resized.png”, the format is deduced from the path
    let resized_image_path = format!("src/bin/assets/{}_resized.jpg", image_name);
    resized_image.save(resized_image_path).unwrap();
}