use core::intrinsics::assume;


pub mod llist;
pub mod psf;


/// ### Safety:
/// `val` must be nonzero
#[inline]
pub const unsafe fn fast_non0_log2(val: usize) -> usize {
    assume(val != 0);
    usize::BITS as usize - 1 ^ val.leading_zeros() as usize
}
/// ### Safety:
/// `val` must be nonzero
#[inline]
pub const unsafe fn fast_non0_prev_pow2(val: usize) -> usize {
    assume(val != 0);
    1 << fast_non0_log2(val as usize)
}
/// ### Safety:
/// `val` must be nonzero 
#[inline]
pub const unsafe fn fast_non0_next_pow2(val: usize) -> usize {
    assume(val != 0);
    1 << u64::BITS - (val - 1).leading_zeros() 
}


/// Copy bits from `src` `src_base..src_acme` into `dst` `dst_base..dst_acme`,
/// where the indecies are in bits from the slices' respective bases.
pub fn copy_slice_bits(dst: *mut [u8], src: *const [u8], dst_bit_index: usize, src_bit_index: usize, bit_len: usize) {
    const ONES: u8 = u8::MAX;
    const BITS: usize = 8;
    const LMSK: usize = BITS - 1;

    /*  Strategy, justification, and edge cases:

        ALIGN OFFSET = (DST BASE & WIDTH-1 - SRC BASE & WIDTH-1) & WIDTH-1
        if wrap: PREINIT CARRY
        [ALIGN LOOP, FRONT TO BACK, CARRY FROM BASE]
        if !(wrap ^ ==): APPEND CARRY

        ALIGN OFFSET: 2-1                               (==)
        BACK XX23/4123/412X                      FRONT
        BACK Y234/1234/12YY                      FRONT

        ALIGN OFFSET: 1-2; PREINIT CARRY; APPEND CARRY  (wrap & ==)
        BACK      X234/1234/12XX                 FRONT
        BACK YY23/4123/412Y                      FRONT

        ALIGN OFFSET: 3-0; APPEND CARRY                 (>)
        BACK 2349/2348                           FRONT
        BACK Y234/9234/8YYY                      FRONT

        ALIGN OFFSET: 0-3; PREINIT CARRY                (wrap & <)
        BACK X234/9234/8XXX                      FRONT
        BACK 2349/2348                           FRONT
    */

    if bit_len == 0 { return; }

    let src_index_base = src_bit_index / BITS;
    let src_index_acme = (src_bit_index + bit_len - 1) / BITS;
    let dst_index_base = dst_bit_index / BITS;
    let dst_index_acme = (dst_bit_index + bit_len - 1) / BITS;

    assert!(src_index_acme < src.len());
    assert!(dst_index_acme < dst.len());

    let dst_base_ptr = unsafe { dst.get_unchecked_mut(dst_index_base) };
    let dst_acme_ptr = unsafe { dst.get_unchecked_mut(dst_index_base) };

    // preserve destination bits that shouldn't be overwritten
    let dst_first_ext = unsafe { *dst_base_ptr } & (1 << (dst_bit_index & LMSK)) - 1;
    let dst_last_ext  = unsafe { *dst_acme_ptr } & !(ONES >> BITS - ((dst_bit_index + bit_len) & LMSK));

    
    let (diff_base, diff_wraps) = (dst_bit_index & LMSK).overflowing_sub(src_bit_index & LMSK);
    // if diff wraps, `& LMSK` will get `BITS - |dst align - src align|`, effectively turning ROL into ROR
    let bit_align_offset = (diff_base & LMSK) as u32;
    let bit_carry_mask = (1 << bit_align_offset) - 1;
    
    let mut src_index = src_index_base;
    let mut dst_index = dst_index_base;
    let mut carry = 0;

    if diff_wraps {
        // handle the wrapping case (implicitly also when src_index_size > dst_index_size)
        // use the first element of src to pre-initialize carry
        carry = unsafe { *src.get_unchecked(src_index) }.rotate_left(bit_align_offset) & bit_carry_mask;
        // bump index
        src_index += 1;
    }

    while src_index <= src_index_acme {
        let rol = unsafe { *src.get_unchecked(src_index) }.rotate_left(bit_align_offset);
        // write the aligned value, swapping in the carry
        unsafe { *dst.get_unchecked_mut(dst_index) = rol & !bit_carry_mask | carry; }
        // extract the new carry
        carry = rol & bit_carry_mask;

        dst_index += 1;
        src_index += 1;
    }

    if !(diff_wraps ^ (dst_index_acme - dst_index_base == src_index_acme - src_index_base)) {
        // handle both the wrapping & equal length case and the nonwrapping & unequal length case
        // append the carried value into the final dst element
        // dst_index is already bumped
        unsafe { *dst.get_unchecked_mut(dst_index) = carry; }
    }

    // clear and restore adjacent, overwritten bits
    unsafe {
        *dst_base_ptr = *dst_base_ptr & ONES << (dst_bit_index & LMSK)                      | dst_first_ext;
        *dst_acme_ptr = *dst_acme_ptr & ONES >> (BITS - ((dst_bit_index + bit_len) & LMSK)) | dst_last_ext;
    }
}
