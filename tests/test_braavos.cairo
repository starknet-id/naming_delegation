%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from src.braavos import domain_to_address, claim_name, transfer_name, _get_amount_of_chars, open_registration, close_registration
from starkware.cairo.common.math import split_felt
from starkware.cairo.common.uint256 import Uint256

@external
func test_claim_name{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    // Should resolve to 123 because we'll register it (with the encoded domain "thomas").
    let (prev_owner) = domain_to_address(1, new (1426911989));
    assert prev_owner = 0;

    %{ stop_prank_callable = start_prank(123) %}
    open_registration();
    claim_name(1426911989);

    let (owner) = domain_to_address(1, new (1426911989));
    assert owner = 123;

    // Should resolve to 456 because we'll change the resolving value (with the encoded domain "thomas").
    transfer_name(1426911989, 456);
    %{ stop_prank_callable() %}
    let (owner) = domain_to_address(1, new (1426911989));
    assert owner = 456;

    return ();
}

@external
func test_claim_not_allowed_name{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    // Should revert because of names are less than 4 chars (with the encoded domain "ben").
    %{ 
        stop_prank_callable = start_prank(123)
        expect_revert(error_message="You can not mint Braavos name with less than 4 letters.") 
     %}
    open_registration();
    claim_name(18925);

    return ();
}

@external
func test_claim_taken_name{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    // Should revert because the name is taken (with the encoded domain "thomas").
    %{ 
        stop_prank_callable = start_prank(123)
     %}
    open_registration();
    claim_name(1426911989);
    %{ 
        stop_prank_callable()
        stop_prank_callable = start_prank(789)
        expect_revert(error_message="This Braavos name is taken.") 
     %}
    claim_name(1426911989);

    return ();
}

@external
func test_claim_two_names{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    // Should revert because the name is taken (with the encoded domain "thomas" and "motty").
    %{ 
        stop_prank_callable = start_prank(123)
     %}
    open_registration();
    claim_name(1426911989);
    %{ 
        expect_revert(error_message="You can not mint any Braavos name again.") 
     %}
    claim_name(51113812);

    return ();
}

@external
func test_open_registration{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    // Should revert because the mint is closed (with the encoded domain "thomas").
    %{ 
        expect_revert(error_message="The registration of Braavos name is closed.") 
     %}
    claim_name(1426911989);

    // Should revert because be able to claim the first time but not the second time
    %{ 
        stop_prank_callable = start_prank(123)
     %}
    open_registration();
    claim_name(1426911989);
    close_registration();
    %{ 
        stop_prank_callable()
        stop_prank_callable = start_prank(789)
        expect_revert(error_message="The registration of Braavos name is closed.") 
     %}
    claim_name(51113812);

    return ();
}

@external
func test_get_amount_of_chars{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    // Should return 0 (empty string)
    let chars_amount = _get_amount_of_chars(Uint256(0, 0));
    assert chars_amount = 0;

    // Should return 4 ("toto")
    let chars_amount = _get_amount_of_chars(Uint256(796195, 0));
    assert chars_amount = 4;

    // Should return 5 ("aloha")
    let chars_amount = _get_amount_of_chars(Uint256(77554770, 0));
    assert chars_amount = 5;

    // Should return 9 ("chocolate")
    let chars_amount = _get_amount_of_chars(Uint256(19565965532212, 0));
    assert chars_amount = 9;

    // Should return 30 ("这来abcdefghijklmopqrstuvwyq1234")
    let (high, low) = split_felt(801855144733576077820330221438165587969903898313);
    let chars_amount = _get_amount_of_chars(Uint256(low, high));
    assert chars_amount = 30;

    return ();
}