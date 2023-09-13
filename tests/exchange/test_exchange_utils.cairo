use starknet::{
    ContractAddress, get_caller_address, get_contract_address, Felt252TryIntoContractAddress, contract_address_const
};
use snforge_std::{declare, start_prank, stop_prank, start_roll, ContractClassTrait};

use satoru::data::keys;
use satoru::data::data_store::{IDataStoreDispatcher, IDataStoreDispatcherTrait};
use satoru::exchange::exchange_utils::validate_request_cancellation;
use satoru::tests_lib::{setup, teardown};

#[test]
fn test_exchange_utils() {
    // Setup
    let (_, _, data_store) = setup();
    let contract_address = contract_address_const::<0>();

    // Test
    let expiration_age = 5;
    data_store.set_u128(keys::request_expiration_block_age(), expiration_age);

    let created_at_block = 10;

    start_roll(contract_address, 9);
    validate_request_cancellation(data_store, created_at_block, 'SOME_REQUEST_TYPE');

    start_roll(contract_address, 10);
    validate_request_cancellation(data_store, created_at_block, 'SOME_REQUEST_TYPE');

    start_roll(contract_address, 14);
    validate_request_cancellation(data_store, created_at_block, 'SOME_REQUEST_TYPE');

    // Teardown
    teardown(data_store.contract_address);
}

#[test]
#[should_panic(expected: ('request_not_yet_cancellable', 'SOME_REQUEST_TYPE'))]
fn test_exchange_utils_fail() {
    // Setup
    let (_, _, data_store) = setup();
    let contract_address = contract_address_const::<0>();

    // Test
    let expiration_age = 5;
    data_store.set_u128(keys::request_expiration_block_age(), expiration_age);

    let created_at_block = 10;

    start_roll(contract_address, 16);
    validate_request_cancellation(data_store, created_at_block, 'SOME_REQUEST_TYPE');
}
