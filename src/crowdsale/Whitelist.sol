pragma solidity ^0.4.21;

import "./Ownable.sol";

contract Whitelist is Ownable{

  address public opsAddress;
  mapping(address => uint8) public whitelist;

  event WhitelistUpdated(address indexed _account, uint8 _phase);

  function isWhitelisted(address _account) constant returns (bool) {
      return whitelist[_account] == 1;
  }

  /**
 *  @notice function to whitelist an address which can be called only by the ops address.
 *
 *  @param _account account address to be whitelisted
 *  @param _phase 0: unwhitelisted, 1: whitelisted

 *
 *  @return bool address is successfully whitelisted/unwhitelisted.
 */
function updateWhitelist(
    address _account,
    uint8 _phase)
    returns (bool)
{
    require(_account != address(0));
    require(_phase <= 1);
    require(isOps(msg.sender));

    whitelist[_account] = _phase;

    emit WhitelistUpdated(_account, _phase);

    return true;
}


  /** Internal Functions */
  /**
   *  @notice checks If the sender is the owner of the contract.
   *
   *  @param _address address to be checked if valid owner or not.
   *
   *  @return bool valid owner or not.
   */
  function isOwner(
      address _address)
      internal
      view
      returns (bool)
  {
      return (_address == owner);
  }
  /**
   *  @notice check If the sender is the ops address.
   *
   *  @param _address address to be checked for ops.
   *
   *  @return bool valid ops or not.
   */
  function isOps(
      address _address)
      internal
      view
      returns (bool)
  {
      return (opsAddress != address(0) && _address == opsAddress);
  }

  /** External Functions */

  /**
   *  @notice Owner can change the verified operator address.
   *
   *  @param _opsAddress address to be set as ops.
   *
   *  @return bool address is successfully set as ops or not.
   */
  function setOpsAddress(
      address _opsAddress)
      external
      onlyOwner
      returns (bool)
  {
      require(_opsAddress != owner);
      require(_opsAddress != address(this));
      require(_opsAddress != address(0));

      opsAddress = _opsAddress;

      return true;
  }

}
