%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.starknet.common.syscalls import get_caller_address

@storage_var
func name_owners(name) -> (owner: felt) {
}

@external
func domain_to_address{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    domain_len: felt, domain: felt*
) -> (address: felt) {
    assert domain_len = 1;
    let (owner) = name_owners.read([domain]);
    return (owner,);
}

@external
func claim_name{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(name: felt) -> () {
    let (owner) = name_owners.read(name);
    assert owner = 0;
    let (caller) = get_caller_address();
    name_owners.write(name, caller);
    return ();
}

@external
func transfer_name{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    name: felt, new_owner: felt
) -> () {
    let (owner) = name_owners.read(name);
    let (caller) = get_caller_address();
    assert owner = caller;
    name_owners.write(name, new_owner);
    return ();
}
