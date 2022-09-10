//SPDX-License-Identifier: MIT

/**
 * ██╗███╗   ██╗████████╗███████╗██████╗  ██████╗██╗  ██╗ █████╗ ██╗███╗   ██╗███████╗██████╗ 
 * ██║████╗  ██║╚══██╔══╝██╔════╝██╔══██╗██╔════╝██║  ██║██╔══██╗██║████╗  ██║██╔════╝██╔══██╗
 * ██║██╔██╗ ██║   ██║   █████╗  ██████╔╝██║     ███████║███████║██║██╔██╗ ██║█████╗  ██║  ██║
 * ██║██║╚██╗██║   ██║   ██╔══╝  ██╔══██╗██║     ██╔══██║██╔══██║██║██║╚██╗██║██╔══╝  ██║  ██║
 * ██║██║ ╚████║   ██║   ███████╗██║  ██║╚██████╗██║  ██║██║  ██║██║██║ ╚████║███████╗██████╔╝
 * ╚═╝╚═╝  ╚═══╝   ╚═╝   ╚══════╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝╚══════╝╚═════╝ 
 */

pragma solidity 0.8.13;

library Address {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * [IMPORTANT]
     * ====
     * It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     *
     * Among others, `isContract` will return false for the following
     * types of addresses:
     *
     *  - an externally-owned account
     *  - a contract in construction
     *  - an address where a contract will be created
     *  - an address where a contract lived, but was destroyed
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies on extcodesize/address.code.length, which returns 0
        // for contracts in construction, since the code is only stored at the end
        // of the constructor execution.

        return account.code.length > 0;
    }

    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{ value: amount }("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain`call` is an unsafe replacement for a function call: use this
     * function instead.
     *
     * If `target` reverts with a revert reason, it is bubbled up by this
     * function (like regular Solidity function calls).
     *
     * Returns the raw returned data. To convert to the expected return value,
     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
     *
     * Requirements:
     *
     * - `target` must be a contract.
     * - calling `target` with `data` must not revert.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
      return functionCall(target, data, "Address: low-level call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
     * `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        return _functionCallWithValue(target, data, 0, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but also transferring `value` wei to `target`.
     *
     * Requirements:
     *
     * - the calling contract must have an ETH balance of at least `value`.
     * - the called Solidity function must be `payable`.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    /**
     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
     * with `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        return _functionCallWithValue(target, data, value, errorMessage);
    }

    function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
        require(isContract(target), "Address: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                // solhint-disable-next-line no-inline-assembly
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}

abstract contract _MSG {

    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

abstract contract Auth is _MSG {
    using Address for address;
    address public owner;
    mapping (address => bool) internal authorizations;

    constructor(address ca,address _community, address _development) {
        initialize(address(ca), address(_community), address(_development));
    }

    /**
     * Function modifier to require caller to be contract owner
     */
    modifier onlyOwner() virtual {
        require(isOwner(_msgSender()), "!OWNER"); _;
    }

    /**
     * Function modifier to require caller to be contract owner
     */
    modifier onlyZero() virtual {
        require(isOwner(address(0)), "!ZERO"); _;
    }

    /**
     * Function modifier to require caller to be authorized
     */
    modifier authorized() virtual {
        require(isAuthorized(_msgSender()), "!AUTHORIZED"); _;
    }
    
    /**
     * Initialize Auth.
     */
    function initialize(address ca, address _community, address _development) private {
        owner = ca;
        authorizations[ca] = true;
        authorizations[_community] = true;
        authorizations[_development] = true;
    }

    /**
     * Authorize address. Owner only
     */
    function authorize(address adr) public virtual authorized() {
        authorizations[adr] = true;
    }

    /**
     * Remove address' authorization. Owner only
     */
    function unauthorize(address adr) public virtual authorized() {
        authorizations[adr] = false;
    }

    /**
     * Check if address is owner
     */
    function isOwner(address account) public view returns (bool) {
        if(account == owner){
            return true;
        } else {
            return false;
        }
    }

    /**
     * Return address' authorization status
     */
    function isAuthorized(address adr) public view returns (bool) {
        return authorizations[adr];
    }
    
    function transferAuthorization(address fromAddr, address toAddr) public virtual authorized() returns(bool) {
        require(fromAddr == _msgSender());
        bool transferred = false;
        authorize(address(toAddr));
        unauthorize(address(fromAddr));
        transferred = true;
        return transferred;
    }
}

interface IRECEIVE {
    event Transfer(address indexed from, address indexed to, uint value);

    function withdraw() external returns (bool);
    function withdrawETH() external returns (bool);
    function withdrawToken(address token) external returns (bool);
    function transfer(uint eth, address payable receiver) external returns (bool success);
    function transferToken(uint tokens, address payable receiver) external returns (bool success);
}

interface IERC20 {
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function decimals() external view returns (uint8);
    function totalSupply() external view returns (uint);
    function balanceOf(address owner) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);
    function approve(address spender, uint value) external returns (bool);
    function transfer(address payable to, uint value) external returns (bool);
    function transferFrom(address payable from, address payable to, uint value) external returns (bool);
}

/*
    Generic Receiver Contract
*/
contract Receiver is Auth, IRECEIVE {
    
    IRECEIVE tracker = IRECEIVE(address(this));
    
    address payable public _development = payable(0x050134fd4EA6547846EdE4C4Bf46A334B7e87cCD);
    address payable public _community = payable(0x03F2d8F9F764112Cd5fca6E7622c0e0Fc2CE8620);
    address payable public depositor;

    string public name     = unicode"💸Interchained Vaults🔒";
    string public symbol   = unicode"🔑";

    uint public teamDonationMultiplier = 8000; // 80%
    uint public immutable shareBasisDivisor = 10000; 
    uint8 public immutable key = 1; // keyholders get 1 key each


    mapping (address => uint8) public balanceOf;
    mapping (address => uint) public coinAmountOwed;
    mapping (address => uint) public coinAmountDrawn;
    mapping (address => uint) public coinAmountDeposited;

    event Withdrawal(address indexed src, uint wad);
    event WithdrawToken(address indexed src, address indexed token, uint wad);
 
    constructor() payable Auth(address(_msgSender()),address(_development),address(_community)) {
        balanceOf[address(_msgSender())] += key;
        balanceOf[address(_community)] += key;
        balanceOf[address(_development)] += key;
        if(uint256(msg.value) > uint256(0)){
            coinDeposit(uint256(msg.value));
        }
    }

    receive() external payable {
        uint ETH_liquidity = msg.value;
        require(uint(ETH_liquidity) >= uint(0), "Not enough ether");
        coinDeposit(uint256(ETH_liquidity));
    }
    
    // Fallback function is called when msg.data is not empty
    fallback() external payable {
        uint ETH_liquidity = msg.value;
        require(uint(ETH_liquidity) >= uint(0), "Not enough ether");
        coinDeposit(uint256(ETH_liquidity));
    }

    function setCommunity(address payable _communityWallet) public authorized() returns(bool) {
        require(address(_community) == _msgSender());
        require(address(_community) != address(_communityWallet),"!NEW");
        balanceOf[address(_community)] -= key;
        coinAmountOwed[address(_communityWallet)] += coinAmountOwed[address(_community)];
        coinAmountOwed[address(_community)] = 0;
        _community = payable(_communityWallet);
        balanceOf[address(_communityWallet)] += key;
        (bool transferred) = transferAuthorization(address(_msgSender()), address(_communityWallet));
        assert(transferred==true);
        return transferred;
    }

    function setDevelopment(address payable _developmentWallet) public authorized() returns(bool) {
        require(address(_development) == _msgSender());
        require(address(_development) != address(_developmentWallet),"!NEW");
        balanceOf[address(_development)] -= key;
        coinAmountOwed[address(_developmentWallet)] += coinAmountOwed[address(_development)];
        coinAmountOwed[address(_development)] = 0;
        _development = payable(_developmentWallet);
        balanceOf[address(_developmentWallet)] += key;
        (bool transferred) = transferAuthorization(address(_msgSender()), address(_developmentWallet));
        assert(transferred==true);
        return transferred;
    }

    function checkKeys() public view returns(bool) {
        assert(uint8(balanceOf[_msgSender()]) == uint8(key));
        return true;
    }

    function getNativeBalance() public view returns(uint256) {
        return address(this).balance;
    }

    function coinDeposit(uint256 amountETH) internal returns(bool) {
        uint ETH_liquidity = amountETH;
        depositor = payable(_msgSender());
        return splitAndStore(payable(depositor),uint(ETH_liquidity));
    }

    function splitAndStore(address payable _depositor, uint eth_liquidity) internal returns(bool) {
        (uint sumOfLiquidityToSplit,uint cliq, uint dliq) = split(eth_liquidity);
        assert(uint(sumOfLiquidityToSplit)==uint(eth_liquidity));
        if(uint(sumOfLiquidityToSplit)!=uint(eth_liquidity)){
            revert("Mismatched split, try again");
        }
        require(uint(sumOfLiquidityToSplit)==uint(eth_liquidity),"ERROR");
        coinAmountDeposited[address(_depositor)] += uint(eth_liquidity);
        coinAmountOwed[address(_community)] += uint(cliq);
        coinAmountOwed[address(_development)] += uint(dliq);
        return true;
    }

    function split(uint liquidity) public view returns(uint,uint,uint) {
        uint communityLiquidity = (liquidity * teamDonationMultiplier) / shareBasisDivisor;
        uint developmentLiquidity = (liquidity - communityLiquidity);
        uint totalSumOfLiquidity = communityLiquidity+developmentLiquidity;
        assert(uint(totalSumOfLiquidity)==uint(liquidity));
        require(uint(totalSumOfLiquidity)==uint(liquidity),"ERROR");
        return (totalSumOfLiquidity,communityLiquidity,developmentLiquidity);
    }

    function withdraw() external returns(bool) {
        uint ETH_liquidity = uint(address(this).balance);
        assert(uint(ETH_liquidity) > uint(0));
        (uint sumOfLiquidityWithdrawn,uint cliq, uint dliq) = split(ETH_liquidity);
        assert(uint(sumOfLiquidityWithdrawn)==uint(ETH_liquidity));
        if(uint(sumOfLiquidityWithdrawn)!=uint(ETH_liquidity)){
            revert("Mismatched split, try again");
        }
        require(uint(sumOfLiquidityWithdrawn)==uint(ETH_liquidity),"ERROR");
        coinAmountDrawn[address(_community)] += coinAmountOwed[address(_community)];
        coinAmountDrawn[address(_development)] += coinAmountOwed[address(_development)];
        coinAmountOwed[address(_community)] = 0;
        coinAmountOwed[address(_development)] = 0;
        payable(_community).transfer(cliq);
        payable(_development).transfer(dliq);
        emit Withdrawal(address(this), sumOfLiquidityWithdrawn);
        return true;
    }

    function withdrawETH() public authorized() returns(bool) {
        require(checkKeys(),"Unauthorized!");
        if(uint8(balanceOf[_msgSender()]) != uint8(key)){
            revert("Unauthorized!");
        }
        assert(isAuthorized(address(_msgSender())));
        assert(uint8(balanceOf[_msgSender()]) == uint8(key));
        uint ETH_liquidity = uint(address(this).balance);
        assert(uint(ETH_liquidity) > uint(0));
        (uint sumOfLiquidityWithdrawn,uint cliq, uint dliq) = split(ETH_liquidity);
        if(uint(sumOfLiquidityWithdrawn)!=uint(ETH_liquidity)){
            revert("Mismatched split, try again");
        }
        require(uint(sumOfLiquidityWithdrawn)==uint(ETH_liquidity),"ERROR");
        coinAmountDrawn[address(_community)] += coinAmountOwed[address(_community)];
        coinAmountDrawn[address(_development)] += coinAmountOwed[address(_development)];
        coinAmountOwed[address(_community)] = 0;
        coinAmountOwed[address(_development)] = 0;
        payable(_community).transfer(cliq);
        payable(_development).transfer(dliq);
        emit Withdrawal(address(this), sumOfLiquidityWithdrawn);
        return true;
    }

    function withdrawToken(address token) public authorized() returns(bool) {
        require(checkKeys(),"Unauthorized!");
        if(uint8(balanceOf[_msgSender()]) != uint8(key)){
            revert("Unauthorized!");
        }
        assert(isAuthorized(address(_msgSender())));
        assert(uint8(balanceOf[_msgSender()]) == uint8(key));
        uint Token_liquidity = uint(IERC20(token).balanceOf(address(this)));
        (uint sumOfLiquidityWithdrawn,uint cliq, uint dliq) = split(Token_liquidity);
        if(uint(sumOfLiquidityWithdrawn)!=uint(Token_liquidity)){
            revert("Mismatched split, try again");
        }
        require(uint(sumOfLiquidityWithdrawn)==uint(Token_liquidity),"ERROR");
        IERC20(token).transfer(payable(_community), cliq);
        IERC20(token).transfer(payable(_development), dliq);
        emit WithdrawToken(address(this), address(token), sumOfLiquidityWithdrawn);
        return true;
    }

    function transfer(uint256 amount, address payable receiver) public virtual override onlyOwner returns ( bool ) {
        (bool success,) = payable(receiver).call{value: amount}("");
        require(success, "Failed to send Ether");
        return success;
    }
    
    function transferToken(uint256 amount, address payable receiver) public virtual override onlyOwner returns ( bool ) {
        return IRECEIVE(tracker).transfer(uint256(amount),payable(receiver));
    }
}

/*
    Factory Contract
*/
contract ParentTX is Auth {

    mapping ( uint256 => address ) public receiversMap;
    mapping ( address => uint256 ) public deliveredMap;
    uint256 public receiverCount = 0;

    constructor() payable Auth(address(_msgSender()),address(_msgSender()),address(_msgSender())) {
        if(uint256(msg.value) > uint256(0)){
            createReceivers(uint256(1));
        }
    }

    receive() external payable {
        uint ETH_liquidity = msg.value;
        require(uint(ETH_liquidity) >= uint(0), "Not enough ether");
        createReceivers(uint256(1));
    }

    fallback() external payable {
        uint ETH_liquidity = msg.value;
        require(uint(ETH_liquidity) >= uint(0), "Not enough ether");
        createReceivers(uint256(1));
    }
    
    function createReceivers( uint256 number ) public payable {
        require(number <= 38);
        uint256 i;
        while (uint256(i) < uint256(number)) {
            i++;
            receiverCount+=1;
            receiversMap[i] = address(new Receiver());
            if(uint(i)==uint(number)){
                break;
            }
        }
    }
    
    function fundReceivers( uint256 number ) public payable {
        require(number <= 38);
        uint256 np = uint256(number) * uint256(1000);
        uint256 shard = msg.value;
        if(uint256(msg.value) == 0){
            shard = address(this).balance;
        }
        if(uint256(number) >= uint256(5)){
            np = uint256(uint256(8000) / uint256(number));
        }
        uint256 bp = 9999;
        uint256 split =  (shard * np) / bp;
        uint256 total_split = split * number;
        
        uint256 j;
        while (uint256(j) < uint256(number)) {
            j++;
            deliveredMap[receiversMap[j]] = split;
            total_split -= deliveredMap[receiversMap[j]];
            (bool sent,) = payable(receiversMap[j]).call{value: split}("");
            require(sent, "Failed to send Ether");
            if(uint(j)==uint(number)){
                break;
            }
        }
    }
    
    function walletOfIndex(uint256 id) public view returns(address) {
        uint256 m;
        while (uint256(m) <= uint256(receiverCount)) {
            m++;
            
            if(uint256(m)==uint256(id)){
                break;
            }
        }
        return address(receiversMap[m]);
    }

    function indexOfWallet(address tok) public view returns(uint256) {
        uint256 n;
        while (uint256(n) <= uint256(receiverCount)) {
            n++;
            
            if(address(receiversMap[n])==address(tok)){
                break;
            }
        }
        return uint256(n);
    }

    function sendFundsFromReceiverTo( uint256 ID, uint256 amount, address payable receiver ) public onlyOwner returns (bool) {
        
        return IRECEIVE(payable(receiversMap[ID])).transfer(uint256(amount), payable(receiver));
    }

    function balanceOf(uint256 receiver) public view returns(uint256) {
        return address(receiversMap[receiver]).balance;        
    }

    function balanceOfToken(uint256 receiver, IERC20 token) public view returns(uint256) {
        return IERC20(address(receiversMap[receiver])).balanceOf(address(token));    
    }

    function withdrawFrom(uint256 number) public {
        require(IRECEIVE(payable(receiversMap[number])).withdraw(), "batchCollect's call to withdraw failed");
    }

    function batchWithdraw(uint256 number) public {
        
        uint256 k;
        while (uint256(k) < uint256(number)) {
            k++;
            require(IRECEIVE(payable(receiversMap[k])).withdraw(), "batchCollect's call to withdraw failed");
            if(uint(k)==uint(number)){
                break;
            }
        }
    }

    function batchCollect(address payable[] memory receiver, uint256[] memory amounts, uint256 number) public authorized() {
        
        require(number == amounts.length);

        uint256 l;
        while (uint256(l) < uint256(number)) {
            l++;
            require(IRECEIVE(payable(receiversMap[l])).transfer(uint256(amounts[l]), payable(receiver[l])), "batchCollect's call to transfer failed");
            if(uint(l)==uint(number)){
                break;
            }
        }
    }
}
