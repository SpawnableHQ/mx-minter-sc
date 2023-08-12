// Code generated by the multiversx-sc multi-contract system. DO NOT EDIT.

////////////////////////////////////////////////////
////////////////// AUTO-GENERATED //////////////////
////////////////////////////////////////////////////

// Init:                                 1
// Endpoints:                            8
// Async Callback (empty):               1
// Total number of exported functions:  10

#![no_std]
#![feature(lang_items)]

multiversx_sc_wasm_adapter::allocator!();
multiversx_sc_wasm_adapter::panic_handler!();

multiversx_sc_wasm_adapter::endpoints! {
    spawner
    (
        init => init
        addAdmin => add_admin
        removeAdmin => remove_admin
        getAdmins => admins
        setObjectRoyalties => set_object_royalties_endpoint
        spawnObject => spawn_object_endpoint
        spawnContract => spawn_contract_endpoint
        respawnContract => respawn_contract_endpoint
        getContracts => contracts
    )
}

multiversx_sc_wasm_adapter::async_callback_empty! {}
