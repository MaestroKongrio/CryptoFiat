pragma soliditypragma solidity ^0.4.16;

contract CryptoFiat {

	string description;
	address owner;
	address minter;

	uint totalSupply;

	struct Account{
		uint balance;
		bool enabled;
	}
	mapping(address => Account) Accounts;

	function CryptoFiat(string fiatDescription) {
		description  = fiatDescription;
		owner = msg.sender;
		minter = msg.sender;
		totalSupply = 0;
	}

	//This function enables an address to operate with the CryptoFiat
	function CreateAccount(address accountNumber) 
	public 
	returns (bool result)
	{
		if (msg.sender != owner) revert();
		Accounts[accountNumber] = Account(0,true);
		return true;
	}
	
	//This function prevent an account from sending/receiving token
	//good for security or regulatory issues
    function FreezeAccount(address accountNumber) 
    public
    returns (bool result)    
    {
        if(msg.sender != owner) revert();
        Accounts[accountNumber].enabled=false;
        return true;
    }

    function UnfreezeAccount(address accountNumber)
    public
    returns (bool result) 
    {
        if(msg.sender != owner) revert();
        Accounts[accountNumber].enabled=true;
        return true;        
    }

	function Mint(address destination,uint quantity) 
	public
	returns (bool result)
	{
        if(msg.sender !=owner) revert();
        //If account is enabled to operate, we add the fresh minted tokens
        totalSupply += quantity;
        if(Accounts[destination].enabled==false) {
            totalSupply -= quantity;
            return false;
        } else {
            Accounts[destination].balance += quantity;
            return true;
        }
	}

    function Redeem(address requester,uint quantity) 
    public
    returns (bool result) 
    {
        if(msg.sender != owner) revert();
        if(Accounts[requester].enabled == false || Accounts[requester].balance<quantity) {
            return false;
        } else {
            totalSupply -= quantity;
            return true;
        }
    }
    
    function Transfer(address destination,uint quantity) 
    public
    returns (bool result)
    {
        //check if destination, target and balance are ok
        if (Accounts[msg.sender].enabled == false ||
            Accounts[destination].enabled == false ||
            Accounts[msg.sender].balance <= quantity) {
                return false;
            } else {
                Accounts[msg.sender].balance -= quantity;
                Accounts[destination].balance += quantity;
                return true;
            }
    }

    function GetStatus(address target)
    constant
    public 
    returns (bool enabled,uint balance) {
        return (Accounts[target].enabled,Accounts[target].balance);
    }

}