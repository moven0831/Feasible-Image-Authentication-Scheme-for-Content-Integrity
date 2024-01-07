use image::{GenericImageView, imageops};

fn main() {
    let image_name = "c2pa_tiny";
    let image_path = format!("src/bin/assets/{}.jpg", image_name);
    let mut img = image::open(image_path).unwrap();

    let crop_x = 50;
    let crop_y = 50;
    let crop_width = 10;
    let crop_height = 10;

    let cropped_image = imageops::crop(&mut img, crop_x, crop_y, crop_width, crop_height).to_image();
    assert!(cropped_image.dimensions() == (crop_width, crop_height));

    // Save the image as “cropped.png”, the format is deduced from the path
    let cropped_image_path = format!("src/bin/assets/{}_cropped.jpg", image_name);
    cropped_image.save(cropped_image_path).unwrap();
}