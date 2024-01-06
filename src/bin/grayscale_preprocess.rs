use image::{GenericImageView, imageops};

fn main() {
    let image_name = "c2pa_mini";
    let image_path = format!("src/bin/assets/{}.jpg", image_name);
    let img = image::open(image_path).unwrap();

    let (width, height) = img.dimensions();
    let mut grayscaled_image = image::ImageBuffer::new(width, height);

    for (x, y, pixel) in img.pixels() {
        let gray = ((pixel[0] as u16 * 30 + pixel[1] as u16 * 59 + pixel[2] as u16 * 11) / 100) as u8;
        grayscaled_image.put_pixel(x, y, image::Rgb([gray, gray, gray]));
    }


    // Save the image as “resized.png”, the format is deduced from the path
    let grayscale_image_path = format!("src/bin/assets/{}_grayscale.jpg", image_name);
    grayscaled_image.save(grayscale_image_path).unwrap();
}