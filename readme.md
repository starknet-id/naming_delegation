# Resolver delegation for creating subdomains

In [Starknet ID naming contract](https://github.com/starknet-id/naming_contract) you can set a resolver contract to your domain to delegate the resolving of your subdomains to this new contract. This repository shows you a template of contracts that you can set as the resolver for your domain.

**Let's take an example with Braavos**

If the domain owner of braavos.stark wants to issue subdomains to it's user. He'll be able to deploy one of the contracts of this repo and use the function `set_domain_to_resolver` of the [Starknet ID naming contract](https://github.com/starknet-id/naming_contract) to set it's address.

The naming contract will then delegate the resolving to the contract set as resolver. When someone will call `domain_to_address` with a braavos subdomain on the naming contract (like `fricoben.braavos.stark`). The naming contract will call the function `domain_to_address` of the resolver contract you set instead of resolving the domain himself.

For this Braavos example it permitted us to send the domain without and identity NFT linked to it and Braavos is really in control of how they distribute their subdomains (see more in `Braavos.cairo` file).

Reach out to [Fricoben](https://twitter.com/fricoben) or [Th0rgal](https://twitter.com/Th0rgal_) if you need any help with that kind of delegation for your business.
