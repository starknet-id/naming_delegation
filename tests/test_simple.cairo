%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from src.simple import domain_to_address, claim_name, transfer_name

@external
func test_using_name{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    let (prev_owner) = domain_to_address(1, new ('thomas'));
    assert prev_owner = 0;

    %{ stop_prank_callable = start_prank(123) %}
    claim_name('thomas');

    let (owner) = domain_to_address(1, new ('thomas'));
    assert owner = 123;

    transfer_name('thomas', 456);
    %{ stop_prank_callable() %}

    let (owner) = domain_to_address(1, new ('thomas'));
    assert owner = 456;

    return ();
}
