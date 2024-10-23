use std::ffi::{CStr, CString};
use std::fs::File;
use std::io::BufReader;
use std::os::raw::c_char;
use std::path::Path;
use image::ImageReader;
use image::ImageFormat;


mod image_data;
mod process_file_response;

/// # Safety
/// 
/// This function dereferences a raw pointer. The caller must ensure that the pointer is valid
/// and points to a null-terminated C string.
pub unsafe fn cstring_to_string(input: *const c_char) -> String {
    let c_str: &CStr = CStr::from_ptr(input);
    let str_slice: &str = c_str.to_str().unwrap();
    str_slice.to_owned()
}

pub fn create_empty_image_data() -> image_data::ImageData {
    image_data::ImageData {
        absolute_path: std::ptr::null(),
        format: std::ptr::null(),
        width: 0,
        height: 0,
        hash: std::ptr::null(),
    }
}

pub fn generate_hash(path: &String) -> String {
    sha256::try_digest(Path::new(&path)).unwrap()
}

pub fn determine_format(reader: &ImageReader<BufReader<File>>, path_str: &String) -> String {
    match reader.format() {
        Some(format) => {
            match format {
                ImageFormat::Png => String::from("png"),
                ImageFormat::Jpeg => String::from("jpeg"),
                ImageFormat::Gif => String::from("gif"),
                ImageFormat::WebP => String::from("webp"),
                ImageFormat::Tiff => String::from("tiff"),
                _ => {
                    // Skip over file.
                    println!("{}: Unsupported format", path_str);
                    String::from("")
                }
            }
        },
        None => {
            // Skip over file.
            println!("{}: Unrecognized format", path_str);
            String::from("")
        }
    }
}

#[no_mangle]
/// # Safety
///
/// This function dereferences a raw pointer. The caller must ensure that the pointer is valid
/// and points to a null-terminated C string.
pub unsafe extern "C" fn process_file(path: *const c_char) -> process_file_response::ProcessFileResponse {
    let path_str = cstring_to_string(path);
    let reader = ImageReader::open(&path_str)
        .unwrap()
        .with_guessed_format()
        .expect("Failed to open image file");

    let format: String = determine_format(&reader, &path_str);

    if format.is_empty() {
        return process_file_response::ProcessFileResponse {
            status: -1,
            image_data: create_empty_image_data(),
        };
    }

    let dimensions = match reader.into_dimensions() {
        Ok(dimensions) => dimensions,
        Err(error) => {
            println!("{}: {}", path_str, error);
            (0, 0)
        }
    };

    if dimensions.0 == 0 && dimensions.1 == 0 {
        return process_file_response::ProcessFileResponse {
            status: -1,
            image_data: create_empty_image_data(),
        };
    }

    let hash_str = generate_hash(&path_str);

    process_file_response::ProcessFileResponse {
        status: 0,
        image_data: image_data::ImageData {
            absolute_path: CString::new(path_str).unwrap().into_raw(),
            format: CString::new(format).unwrap().into_raw(),
            width: dimensions.0,
            height: dimensions.1,
            hash: CString::new(hash_str).unwrap().into_raw(),
        },
    }
}

#[no_mangle]
/// # Safety
///
/// This function takes ownership of raw pointers and converts them back to CString.
/// The caller must ensure that the pointers are valid and were originally created by CString::into_raw.
pub unsafe extern "C" fn free_image_data(image_data: image_data::ImageData) {
    if !image_data.absolute_path.is_null() {
        drop(CString::from_raw(image_data.absolute_path as *mut c_char));
    }
    if !image_data.format.is_null() {
        drop(CString::from_raw(image_data.format as *mut c_char));
    }
    if !image_data.hash.is_null() {
        drop(CString::from_raw(image_data.hash as *mut c_char));
    }
}