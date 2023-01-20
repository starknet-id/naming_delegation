%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from src.simple import domain_to_address, claim_name, transfer_name

@external
func test_claim_name{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    // Should resolve to 123 because we'll register it (with the encoded domain "thomas").
    let (prev_owner) = domain_to_address(1, new (1426911989));
    assert prev_owner = 0;

    %{ stop_prank_callable = start_prank(123) %}
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