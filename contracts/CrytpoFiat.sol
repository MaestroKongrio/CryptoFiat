pragma solidity ^0.4.6;

import "./zeppelin/token/MintableToken.sol";
import "./zeppelin/token/LimitedTransferToken.sol";

contract CryptoFiat is MintableToken, LimitedTransferToken {

	string description;
	address owner;

	function CryptoFiat(string fiatDescription) {
		description  = fiatDescription;
		owner = msg.sender;
	}

}