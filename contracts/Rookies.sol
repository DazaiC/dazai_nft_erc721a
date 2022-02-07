// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import '@openzeppelin/contracts/access/Ownable.sol';
import './ERC721A.sol';
import '@openzeppelin/contracts/utils/Strings.sol';
import '@openzeppelin/contracts/utils/math/SafeMath.sol';

contract Rookies is ERC721A, Ownable {
  using SafeMath for uint256;
  using Strings for uint256;

  // Check sale status
  bool private _isPreSaleActive = false;
  bool private _isPublicSaleActive = false;

  uint256 public offsetIndex = 0;
  uint256 public revealTimeStamp = block.timestamp + 600;
  uint256 public constant PRICE = .001 ether;
  uint256 public constant MAX_SUPPLY = 1000;

  string private _baseTokenURI;
  string private _preRevealURI;

  // Shareholders' address
  address private s1 = 0x00380A88f081020Ae09ab8d19b0c554dB499b66D;
  address private s2 = 0x00380A88f081020Ae09ab8d19b0c554dB499b66D;
  address private s3 = 0x00380A88f081020Ae09ab8d19b0c554dB499b66D;
  address private s4 = 0x00380A88f081020Ae09ab8d19b0c554dB499b66D;
  address private s5 = 0x00380A88f081020Ae09ab8d19b0c554dB499b66D;
  address private s6 = 0x00380A88f081020Ae09ab8d19b0c554dB499b66D;

  // White List
  mapping(address => bool) private _allowList;

  modifier onlyShareHolders() {
    require(msg.sender == s1 || msg.sender == s2 || msg.sender == s3 || msg.sender == s4 || msg.sender == s5 || msg.sender == s6);
    _;
  }

  modifier onlyRealUser() {
    require(msg.sender == tx.origin, 'Oops. Something went wrong !');
    _;
  }

  event PreSale_Started();
  event PreSale_Stopped();
  event PublicSale_Started();
  event PublicSale_Stopped();
  event TokenMinted(uint256 supply);

  constructor() ERC721A('Rookies', 'ROKY') {}

  // Add to white list
  function addToAllowList(address[] calldata addresses) external onlyOwner {
    for (uint256 i = 0; i < addresses.length; i++) {
      require(addresses[i] != address(0), "Can't add the null address");
      _allowList[addresses[i]] = true;
    }
  }

  // Remove from white list
  function removeFromAllowList(address[] calldata addresses) external onlyOwner {
    for (uint256 i = 0; i < addresses.length; i++) {
      require(addresses[i] != address(0), "Can't add the null address");
      _allowList[addresses[i]] = false;
    }
  }

  function onAllowList(address addr) external view returns (bool) {
    return _allowList[addr];
  }

  function startPreSale() public onlyOwner {
    _isPreSaleActive = true;
    emit PreSale_Started();
  }

  function pausePreSale() public onlyOwner {
    _isPreSaleActive = false;
    emit PreSale_Stopped();
  }

  function isPreSaleActive() public view returns (bool) {
    return _isPreSaleActive;
  }

  function startPublicSale() public onlyOwner {
    _isPublicSaleActive = true;
    emit PublicSale_Started();
  }

  function pausePublicSale() public onlyOwner {
    _isPublicSaleActive = false;
    emit PublicSale_Stopped();
  }

  function isPublicSaleActive() public view returns (bool) {
    return _isPublicSaleActive;
  }

  function mint_presale(uint8 NUM_TOKENS_MINT) public payable onlyRealUser {
    require(_isPreSaleActive, 'Sales is not active');
    require(totalSupply().add(NUM_TOKENS_MINT) <= 900, 'Exceeding max supply');
    require(_allowList[msg.sender], 'You are not in the allowList');
    require(NUM_TOKENS_MINT <= 2, 'You can not mint over 2 at a time');
    require(NUM_TOKENS_MINT > 0, 'At least one should be minted');
    require(PRICE * NUM_TOKENS_MINT <= msg.value, 'Not enough ether sent');
    _allowList[msg.sender] = false;

    _mint(msg.sender, NUM_TOKENS_MINT);
    emit TokenMinted(totalSupply());
  }

  function mint_public(uint8 NUM_TOKENS_MINT) public payable onlyRealUser {
    require(_isPublicSaleActive, 'Sales is not active');
    require(totalSupply().add(NUM_TOKENS_MINT) <= 900, 'Exceeding max supply');
    require(NUM_TOKENS_MINT <= 3, 'You can not mint over 3 at a time');
    require(NUM_TOKENS_MINT > 0, 'At least one should be minted');
    require(PRICE * NUM_TOKENS_MINT <= msg.value, 'Not enough ether sent');

    _mint(msg.sender, NUM_TOKENS_MINT);
    emit TokenMinted(totalSupply());
  }

  function _mint(address recipient, uint256 quantity) internal {
    // _safeMint's second argument now takes in a quantity, not a tokenId.
    _safeMint(recipient, quantity);
  }

  function reserve(uint256 num) public onlyOwner {
    require(totalSupply().add(num) <= MAX_SUPPLY, 'Exceeding max supply');

    _mint(msg.sender, num);
    emit TokenMinted(totalSupply());
  }

  function airdrop(uint256 num, address recipient) public onlyOwner {
    require(totalSupply().add(num) <= MAX_SUPPLY, 'Exceeding max supply');

    _mint(recipient, num);
    emit TokenMinted(totalSupply());
  }

  function airdropToMany(address[] memory recipients) external onlyOwner {
    require(totalSupply().add(recipients.length) <= MAX_SUPPLY, 'Exceeding max supply');
    for (uint256 i = 0; i < recipients.length; i++) {
      airdrop(1, recipients[i]);
    }
  }

  function getTime() external view returns (uint256) {
    return block.timestamp;
  }

  function setRevealTimestamp(uint256 newRevealTimeStamp) external onlyOwner {
    revealTimeStamp = newRevealTimeStamp;
  }

  function tokenURI(uint256 tokenId) public view virtual override returns (string memory a) {
    require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
    if (totalSupply() >= MAX_SUPPLY || block.timestamp >= revealTimeStamp) {
      if (tokenId < MAX_SUPPLY) {
        uint256 offsetId = tokenId.add(MAX_SUPPLY.sub(offsetIndex)).mod(MAX_SUPPLY);
        return string(abi.encodePacked(_baseURI(), offsetId.toString(), '.json'));
      }
    } else {
      return _preRevealURI;
    }
  }

  function setBaseURI(string calldata baseURI) external onlyOwner {
    _baseTokenURI = baseURI;
  }

  function setPreRevealURI(string memory preRevealURI) external onlyOwner {
    _preRevealURI = preRevealURI;
  }

  function _baseURI() internal view virtual override returns (string memory) {
    return _baseTokenURI;
  }

  function withdrawMoney() external onlyShareHolders {
    uint256 _each = address(this).balance / 6;
    require(payable(s1).send(_each), 'Send Failed');
    require(payable(s2).send(_each), 'Send Failed');
    require(payable(s3).send(_each), 'Send Failed');
    require(payable(s4).send(_each), 'Send Failed');
    require(payable(s5).send(_each), 'Send Failed');
    require(payable(s6).send(_each), 'Send Failed');
  }

  function getTokenByOwner(address _owner) public view returns (uint256[] memory) {
    uint256 tokenCount = balanceOf(_owner);
    uint256[] memory tokenIds = new uint256[](tokenCount);
    for (uint256 i; i < tokenCount; i++) {
      tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
    }
    return tokenIds;
  }

  function numberMinted(address owner) public view returns (uint256) {
    return _numberMinted(owner);
  }

  function getOwnershipData(uint256 tokenId) external view returns (TokenOwnership memory) {
    return ownershipOf(tokenId);
  }
}
