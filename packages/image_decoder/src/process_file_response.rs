use crate::image_data::ImageData;

// For status, use 0 for success, and -1 for failure.
#[derive(Debug)]
#[repr(C)]
pub struct ProcessFileResponse {
    pub status: i32,
    pub image_data: ImageData,
}
