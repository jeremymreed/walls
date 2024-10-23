use std::os::raw::c_char;

#[derive(Debug)]
#[repr(C)]
pub struct ImageData {
    pub absolute_path: *const c_char,
    pub format: *const c_char,
    pub width: u32,
    pub height: u32,
    pub hash: *const c_char,
}
