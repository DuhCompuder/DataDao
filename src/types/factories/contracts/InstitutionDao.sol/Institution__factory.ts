/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */
import { Signer, utils, Contract, ContractFactory, Overrides } from "ethers";
import type { Provider, TransactionRequest } from "@ethersproject/providers";
import type { PromiseOrValue } from "../../../common";
import type {
  Institution,
  InstitutionInterface,
} from "../../../contracts/InstitutionDao.sol/Institution";

const _abi = [
  {
    inputs: [
      {
        internalType: "string",
        name: "_name",
        type: "string",
      },
      {
        internalType: "address[]",
        name: "owners",
        type: "address[]",
      },
      {
        internalType: "contract IDaoManagerCID",
        name: "_managingDao",
        type: "address",
      },
    ],
    stateMutability: "nonpayable",
    type: "constructor",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "index",
        type: "uint256",
      },
    ],
    name: "approveDealIdentifer",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [],
    name: "approveRegistrant",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [],
    name: "approveReviewer",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    name: "approvedDealIdentifers",
    outputs: [
      {
        internalType: "string",
        name: "title",
        type: "string",
      },
      {
        internalType: "bytes",
        name: "cid",
        type: "bytes",
      },
      {
        internalType: "uint256",
        name: "cidSize",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "timeCreated",
        type: "uint256",
      },
      {
        internalType: "bool",
        name: "approved",
        type: "bool",
      },
      {
        internalType: "uint256",
        name: "voteCount",
        type: "uint256",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "user",
        type: "address",
      },
    ],
    name: "changeRole",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [],
    name: "dealidentiferCount",
    outputs: [
      {
        internalType: "uint256",
        name: "_value",
        type: "uint256",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    name: "docsForApproval",
    outputs: [
      {
        internalType: "string",
        name: "title",
        type: "string",
      },
      {
        internalType: "bytes",
        name: "cid",
        type: "bytes",
      },
      {
        internalType: "uint256",
        name: "cidSize",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "timeCreated",
        type: "uint256",
      },
      {
        internalType: "bool",
        name: "approved",
        type: "bool",
      },
      {
        internalType: "uint256",
        name: "voteCount",
        type: "uint256",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "docsForApprovalCount",
    outputs: [
      {
        internalType: "uint256",
        name: "_value",
        type: "uint256",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "uint64",
        name: "unused",
        type: "uint64",
      },
    ],
    name: "fund",
    outputs: [],
    stateMutability: "payable",
    type: "function",
  },
  {
    inputs: [],
    name: "grantAccress",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [],
    name: "name",
    outputs: [
      {
        internalType: "string",
        name: "",
        type: "string",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "string",
        name: "title",
        type: "string",
      },
      {
        internalType: "bytes",
        name: "cid",
        type: "bytes",
      },
    ],
    name: "registerNewDealIdentifer",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "",
        type: "address",
      },
    ],
    name: "roleOfAccount",
    outputs: [
      {
        internalType: "enum IAMDataDAO.ROLES",
        name: "",
        type: "uint8",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "string",
        name: "newName",
        type: "string",
      },
    ],
    name: "updateName",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "index",
        type: "uint256",
      },
    ],
    name: "voteDealIdentifer",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "bytes",
        name: "",
        type: "bytes",
      },
      {
        internalType: "address",
        name: "",
        type: "address",
      },
    ],
    name: "voters",
    outputs: [
      {
        internalType: "bool",
        name: "",
        type: "bool",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
] as const;

const _bytecode =
  "0x60806040523480156200001157600080fd5b50604051620015fc380380620015fc8339810160408190526200003491620001f0565b60016200004284826200036d565b50600280546001600160a01b0319166001600160a01b03831617905560005b8251811015620000df57600080600085848151811062000085576200008562000439565b6020908102919091018101516001600160a01b03168252810191909152604001600020805460ff19166001836003811115620000c557620000c56200044f565b021790555080620000d68162000465565b91505062000061565b505050506200048d565b634e487b7160e01b600052604160045260246000fd5b604051601f8201601f191681016001600160401b03811182821017156200012a576200012a620000e9565b604052919050565b6001600160a01b03811681146200014857600080fd5b50565b600082601f8301126200015d57600080fd5b815160206001600160401b038211156200017b576200017b620000e9565b8160051b6200018c828201620000ff565b9283528481018201928281019087851115620001a757600080fd5b83870192505b84831015620001d3578251620001c38162000132565b82529183019190830190620001ad565b979650505050505050565b8051620001eb8162000132565b919050565b6000806000606084860312156200020657600080fd5b83516001600160401b03808211156200021e57600080fd5b818601915086601f8301126200023357600080fd5b815181811115620002485762000248620000e9565b60206200025e601f8301601f19168201620000ff565b82815289828487010111156200027357600080fd5b60005b838110156200029357858101830151828201840152820162000276565b506000928101820192909252870151909550915080821115620002b557600080fd5b50620002c4868287016200014b565b925050620002d560408501620001de565b90509250925092565b600181811c90821680620002f357607f821691505b6020821081036200031457634e487b7160e01b600052602260045260246000fd5b50919050565b601f8211156200036857600081815260208120601f850160051c81016020861015620003435750805b601f850160051c820191505b8181101562000364578281556001016200034f565b5050505b505050565b81516001600160401b03811115620003895762000389620000e9565b620003a1816200039a8454620002de565b846200031a565b602080601f831160018114620003d95760008415620003c05750858301515b600019600386901b1c1916600185901b17855562000364565b600085815260208120601f198616915b828110156200040a57888601518255948401946001909101908401620003e9565b5085821015620004295787850151600019600388901b60f8161c191681555b5050505050600190811b01905550565b634e487b7160e01b600052603260045260246000fd5b634e487b7160e01b600052602160045260246000fd5b6000600182016200048657634e487b7160e01b600052601160045260246000fd5b5060010190565b61115f806200049d6000396000f3fe6080604052600436106100f35760003560e01c80637e6e49f01161008a578063ad41628011610059578063ad41628014610262578063cecd7574146102bd578063dd9befbe14610145578063eaf00fd2146102d457600080fd5b80637e6e49f0146101e257806384da92a714610202578063a305d71914610222578063a963c81d1461024257600080fd5b80632cfce79b116100c65780632cfce79b1461015a5780633abc4ef61461018c57806343a6aa39146101b15780634f9c09cc146101d157600080fd5b806306fdde03146100f85780630d0e1900146101235780631493b92b14610145578063222f13bc14610145575b600080fd5b34801561010457600080fd5b5061010d610311565b60405161011a9190610b70565b60405180910390f35b34801561012f57600080fd5b5061014361013e366004610b8a565b61039f565b005b34801561015157600080fd5b50610143610531565b34801561016657600080fd5b5061017a610175366004610b8a565b610591565b60405161011a96959493929190610ba3565b34801561019857600080fd5b506005546101a39081565b60405190815260200161011a565b3480156101bd57600080fd5b506101436101cc366004610b8a565b6106dc565b6101436101df366004610bee565b50565b3480156101ee57600080fd5b506101436101fd366004610c61565b61083e565b34801561020e57600080fd5b5061014361021d366004610d59565b610a27565b34801561022e57600080fd5b5061014361023d366004610dc6565b610aab565b34801561024e57600080fd5b5061017a61025d366004610b8a565b610b0f565b34801561026e57600080fd5b506102ad61027d366004610de1565b81516020818401810180516007825292820194820194909420919093529091526000908152604090205460ff1681565b604051901515815260200161011a565b3480156102c957600080fd5b506006546101a39081565b3480156102e057600080fd5b506103046102ef366004610dc6565b60006020819052908152604090205460ff1681565b60405161011a9190610e59565b6001805461031e90610e81565b80601f016020809104026020016040519081016040528092919081815260200182805461034a90610e81565b80156103975780601f1061036c57610100808354040283529160200191610397565b820191906000526020600020905b81548152906001019060200180831161037a57829003601f168201915b505050505081565b3360009081526020819052604090205460ff1660018160038111156103c6576103c6610e43565b14806103e3575060008160038111156103e1576103e1610e43565b145b6104085760405162461bcd60e51b81526004016103ff90610ebb565b60405180910390fd5b60076003600084815260200190815260200160002060010160405161042d9190610ef2565b9081526040805160209281900383019020336000908152925290205460ff16156104b65760405162461bcd60e51b815260206004820152603460248201527f596f752063616e6e6f7420766f746520666f72207468652073616d6520646f63604482015273756d656e74206d6f7265207468616e206f6e636560601b60648201526084016103ff565b60016007600360008581526020019081526020016000206001016040516104dd9190610ef2565b9081526040805160209281900383019020336000908152908352818120805460ff19169415159490941790935584835260039091528120600501805460019290610528908490610f68565b90915550505050565b3360009081526020819052604090205460ff16600181600381111561055857610558610e43565b14806105755750600081600381111561057357610573610e43565b145b6101df5760405162461bcd60e51b81526004016103ff90610ebb565b6004602052600090815260409020805481906105ac90610e81565b80601f01602080910402602001604051908101604052809291908181526020018280546105d890610e81565b80156106255780601f106105fa57610100808354040283529160200191610625565b820191906000526020600020905b81548152906001019060200180831161060857829003601f168201915b50505050509080600101805461063a90610e81565b80601f016020809104026020016040519081016040528092919081815260200182805461066690610e81565b80156106b35780601f10610688576101008083540402835291602001916106b3565b820191906000526020600020905b81548152906001019060200180831161069657829003601f168201915b5050506002840154600385015460048601546005909601549495919490935060ff909116915086565b3360009081526020819052604090205460ff16600181600381111561070357610703610e43565b14806107205750600081600381111561071e5761071e610e43565b145b61073c5760405162461bcd60e51b81526004016103ff90610ebb565b6000828152600360205260409020600501546107b05760405162461bcd60e51b815260206004820152602d60248201527f446f6573206e6f74206d656574206d696e696d756d20766f746520636f756e7460448201526c08199bdc88185c1c1c9bdd985b609a1b60648201526084016103ff565b600082815260036020526040908190206004808201805460ff1916600190811790915560028054908401549451636a50668560e11b81526001600160a01b039091169463d4a0cd0a9461080894930192909101610f8f565b600060405180830381600087803b15801561082257600080fd5b505af1158015610836573d6000803e3d6000fd5b505050505050565b3360009081526020819052604090205460ff16600181600381111561086557610865610e43565b14806108825750600081600381111561088057610880610e43565b145b8061089e5750600281600381111561089c5761089c610e43565b145b6108f65760405162461bcd60e51b8152602060048201526024808201527f4163636573732044656e6965643a2052656769737472616e747320616e642061604482015263626f766560e01b60648201526084016103ff565b6109316040518060c0016040528060608152602001606081526020016000815260200160008152602001600015158152602001600081525090565b85858080601f016020809104026020016040519081016040528093929190818152602001838380828437600092019190915250505090825250604080516020601f860181900481028201810190925284815290859085908190840183828082843760009201829052506020868101959095524260608701526006548152600390945250506040909120825183925081906109cb9082611069565b50602082015160018201906109e09082611069565b506040820151600282015560608201516003820155608082015160048201805460ff191691151591909117905560a090910151600590910155600680546001019055610836565b3360009081526020819052604081205460ff1690816003811115610a4d57610a4d610e43565b14610a9a5760405162461bcd60e51b815260206004820152601a60248201527f4163636573732044656e6965643a204f776e657273206f6e6c7900000000000060448201526064016103ff565b6001610aa68382611069565b505050565b3360009081526020819052604090205460ff166001816003811115610ad257610ad2610e43565b1480610aef57506000816003811115610aed57610aed610e43565b145b610b0b5760405162461bcd60e51b81526004016103ff90610ebb565b5050565b6003602052600090815260409020805481906105ac90610e81565b6000815180845260005b81811015610b5057602081850181015186830182015201610b34565b506000602082860101526020601f19601f83011685010191505092915050565b602081526000610b836020830184610b2a565b9392505050565b600060208284031215610b9c57600080fd5b5035919050565b60c081526000610bb660c0830189610b2a565b8281036020840152610bc88189610b2a565b604084019790975250506060810193909352901515608083015260a09091015292915050565b600060208284031215610c0057600080fd5b813567ffffffffffffffff81168114610b8357600080fd5b60008083601f840112610c2a57600080fd5b50813567ffffffffffffffff811115610c4257600080fd5b602083019150836020828501011115610c5a57600080fd5b9250929050565b60008060008060408587031215610c7757600080fd5b843567ffffffffffffffff80821115610c8f57600080fd5b610c9b88838901610c18565b90965094506020870135915080821115610cb457600080fd5b50610cc187828801610c18565b95989497509550505050565b634e487b7160e01b600052604160045260246000fd5b600067ffffffffffffffff80841115610cfe57610cfe610ccd565b604051601f8501601f19908116603f01168101908282118183101715610d2657610d26610ccd565b81604052809350858152868686011115610d3f57600080fd5b858560208301376000602087830101525050509392505050565b600060208284031215610d6b57600080fd5b813567ffffffffffffffff811115610d8257600080fd5b8201601f81018413610d9357600080fd5b610da284823560208401610ce3565b949350505050565b80356001600160a01b0381168114610dc157600080fd5b919050565b600060208284031215610dd857600080fd5b610b8382610daa565b60008060408385031215610df457600080fd5b823567ffffffffffffffff811115610e0b57600080fd5b8301601f81018513610e1c57600080fd5b610e2b85823560208401610ce3565b925050610e3a60208401610daa565b90509250929050565b634e487b7160e01b600052602160045260246000fd5b6020810160048310610e7b57634e487b7160e01b600052602160045260246000fd5b91905290565b600181811c90821680610e9557607f821691505b602082108103610eb557634e487b7160e01b600052602260045260246000fd5b50919050565b6020808252601f908201527f4163636573732044656e6965643a2041646d696e7320616e642061626f766500604082015260600190565b6000808354610f0081610e81565b60018281168015610f185760018114610f2d57610f5c565b60ff1984168752821515830287019450610f5c565b8760005260208060002060005b85811015610f535781548a820152908401908201610f3a565b50505082870194505b50929695505050505050565b80820180821115610f8957634e487b7160e01b600052601160045260246000fd5b92915050565b604081526000808454610fa181610e81565b8060408601526060600180841660008114610fc35760018114610fdd5761100e565b60ff1985168884015283151560051b88018301955061100e565b8960005260208060002060005b868110156110055781548b8201870152908401908201610fea565b8a018501975050505b50505050506020929092019290925292915050565b601f821115610aa657600081815260208120601f850160051c8101602086101561104a5750805b601f850160051c820191505b8181101561083657828155600101611056565b815167ffffffffffffffff81111561108357611083610ccd565b611097816110918454610e81565b84611023565b602080601f8311600181146110cc57600084156110b45750858301515b600019600386901b1c1916600185901b178555610836565b600085815260208120601f198616915b828110156110fb578886015182559484019460019091019084016110dc565b50858210156111195787850151600019600388901b60f8161c191681555b5050505050600190811b0190555056fea26469706673582212201c08536bc325d5fb38a48a7123cd875d2ef57fcd37618983c0382e9a192c01bf64736f6c63430008110033";

type InstitutionConstructorParams =
  | [signer?: Signer]
  | ConstructorParameters<typeof ContractFactory>;

const isSuperArgs = (
  xs: InstitutionConstructorParams
): xs is ConstructorParameters<typeof ContractFactory> => xs.length > 1;

export class Institution__factory extends ContractFactory {
  constructor(...args: InstitutionConstructorParams) {
    if (isSuperArgs(args)) {
      super(...args);
    } else {
      super(_abi, _bytecode, args[0]);
    }
  }

  override deploy(
    _name: PromiseOrValue<string>,
    owners: PromiseOrValue<string>[],
    _managingDao: PromiseOrValue<string>,
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<Institution> {
    return super.deploy(
      _name,
      owners,
      _managingDao,
      overrides || {}
    ) as Promise<Institution>;
  }
  override getDeployTransaction(
    _name: PromiseOrValue<string>,
    owners: PromiseOrValue<string>[],
    _managingDao: PromiseOrValue<string>,
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): TransactionRequest {
    return super.getDeployTransaction(
      _name,
      owners,
      _managingDao,
      overrides || {}
    );
  }
  override attach(address: string): Institution {
    return super.attach(address) as Institution;
  }
  override connect(signer: Signer): Institution__factory {
    return super.connect(signer) as Institution__factory;
  }

  static readonly bytecode = _bytecode;
  static readonly abi = _abi;
  static createInterface(): InstitutionInterface {
    return new utils.Interface(_abi) as InstitutionInterface;
  }
  static connect(
    address: string,
    signerOrProvider: Signer | Provider
  ): Institution {
    return new Contract(address, _abi, signerOrProvider) as Institution;
  }
}