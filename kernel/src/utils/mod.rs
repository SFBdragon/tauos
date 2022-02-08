
pub mod llist;
pub mod pinning;


/// Copy bits from `src` `src_base..src_acme` into `dst` `dst_base..dst_acme`,
/// where the indecies are in bits from the slices' respective bases.
pub fn copy_slice_bits(dst: &mut [u64], src: &[u64], dst_bit_index: usize, src_bit_index: usize, bit_len: usize) {
    debug_assert!((src_bit_index | (src_bit_index + bit_len)) >> 6 < src.len());
    debug_assert!((dst_bit_index | (dst_bit_index + bit_len) - 1) >> 6 < dst.len());
    
    /*  Strategy, justification, and edge cases:

        ALIGN OFFSET = (DST BASE & WIDTH-1 - SRC BASE & WIDTH-1) & WIDTH-1
        if wrap: PREINIT CARRY
        [ALIGN LOOP, FRONT TO BACK, CARRY FROM BASE]
        if !(wrap ^ ==): APPEND CARRY

        ALIGN OFFSET: 2-1                               (==)
        BACK 6623/4123/4126                      FRONT
        BACK 5234/1234/1255                      FRONT

        ALIGN OFFSET: 1-2; PREINIT CARRY; APPEND CARRY  (wrap & ==)
        BACK      5234/1234/1255                 FRONT
        BACK 6623/4123/4126                      FRONT

        ALIGN OFFSET: 3-0; APPEND CARRY                 (>)
        BACK 2349/2348                           FRONT
        BACK 5234/9234/8555                      FRONT

        ALIGN OFFSET: 0-3; PREINIT CARRY                (wrap & <)
        BACK 5234/9234/8555                      FRONT
        BACK 2349/2348                           FRONT
    */

    let dst_bit_index_acme = dst_bit_index + bit_len;

    let src_index_base = src_bit_index >> 6;
    let src_index_acme = (src_bit_index + bit_len) - 1 >> 6;
    let dst_index_base = dst_bit_index >> 6;
    let dst_index_acme = dst_bit_index_acme - 1 >> 6;

    // preserve destination bits that shouldn't be overwritten
    let dst_first_ext = dst[dst_index_base] & (1 << (dst_bit_index & 63)) - 1;
    let dst_last_ext  = dst[dst_index_acme] & !(u64::MAX >> (dst_bit_index_acme & 63 ^ 63));

    
    let (diff_base, diff_wraps) = (dst_bit_index & 63).overflowing_sub(src_bit_index & 63);
    // if diff wraps, `& 63` will get `64 - |dst align - src align|`, effectively turning ROL into ROR
    let bit_align_offset = (diff_base & 63) as u32;
    let bit_carry_mask = (1u64 << bit_align_offset) - 1;
    
    let mut src_index = src_index_base;
    let mut dst_index = dst_index_base;
    let mut carry = 0;

    if diff_wraps {
        // handle the wrapping case (implicitly also when src_index_size > dst_index_size)
        // use the first element of src to pre-initialize carry
        carry = src[src_index].rotate_left(bit_align_offset) & bit_carry_mask;
        // bump index
        src_index += 1;
    }

    loop {
        let rol = unsafe { src.get_unchecked(src_index) }.rotate_left(bit_align_offset);
        // write the aligned value, swapping in the carry
        *unsafe { dst.get_unchecked_mut(dst_index) } = rol & !bit_carry_mask | carry;
        // extract the new carry
        carry = rol & bit_carry_mask;

        dst_index += 1;
        if src_index == src_index_acme { break; }
        src_index += 1;
    }

    if !(diff_wraps ^ (dst_index_acme - dst_index_base == src_index_acme - src_index_base)) {
        // handle both the wrapping & equal length case and the nonwrapping & unequal length case
        // append the carried value into the final dst element
        // dst_index is already bumped
        dst[dst_index] = carry;
    }

    // clear and restore adjacent, overwritten bits
    dst[dst_index_base] = dst[dst_index_base] & u64::MAX << (dst_bit_index & 63)           ^ dst_first_ext;
    dst[dst_index_acme] = dst[dst_index_acme] & u64::MAX >> (dst_bit_index_acme & 63 ^ 63) ^ dst_last_ext;
}
