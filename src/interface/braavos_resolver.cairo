%lang starknet
from starkware.cairo.common.uint256 import Uint256

@contract_interface
namespace IBraavosResolver {
    func open_registration() {
    }

    func domain_to_address(domain_len: felt, domain: felt*) -> (address: felt) {
    }

    func claim_name(name: felt) {
    }

    func transfer_name(name: felt, new_owner: felt) {
    }

    func set_wl_class_hash(wl_class_hash: felt) {
    }
}
