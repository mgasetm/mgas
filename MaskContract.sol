// SPDX-License-Identifier: GPL-3.0
// 声明Solidity版本
pragma solidity >=0.7.0 <0.9.0;

// 导入BEP20代币的接口
import "@pancakeswap/pancake-swap-lib/contracts/token/BEP20/IBEP20.sol";


// 定义Cake合约
// 合约地址： 0x40c9e5BE7F1401681dA79dB85c3dB19E33DB73EB
contract CakeContract {
    // 声明代币接口对象
    IBEP20 public cakeToken;

    // 0x2ed9a5c8c13b93955103b9a7c167b67ef4d568a3
    //0x69af81e73a73b40adf4f3d4223cd9b1ece623074
    // 声明结构体用于保存交易记录
    struct Transaction {
        address sender;
        address recipient;
        uint256 amount;
        uint256 timestamp;
    }

    // 声明数组用于保存交易记录
    Transaction[] public transactions;

    // 声明映射表用于保存用户余额
    mapping(address => uint256) public balances;

    // 定义构造函数，接受代币地址作为参数
    // 0x2ed9a5c8c13b93955103b9a7c167b67ef4d568a3
    constructor(address _cakeToken ) {
        // 初始化代币接口对象
        cakeToken = IBEP20(_cakeToken);
    }

    // 授权函数，用于向合约授权使用指定数量的cake币
    function approveToken(uint256 amount) public {
        // 调用代币接口的approve函数，将合约地址设置为目标地址，并授权指定数量的代币
        cakeToken.approve(address(this), amount);
    }

    // 存款函数，用于将cake币存储到合约中
    function deposit(uint256 amount) public {
        // 检查调用者已经授权合约使用足够的代币
        require(
            cakeToken.allowance(msg.sender, address(this)) >= amount,
            "CakeContract: Allowance not enough"
        );
        // 从调用者地址转移指定数量的代币到合约地址
        cakeToken.transferFrom(msg.sender, address(this), amount);
        // 在映射表中更新调用者的余额
        balances[msg.sender] += amount;
        // 添加交易记录到列表中
        transactions.push(
            Transaction(msg.sender, address(this), amount, block.timestamp)
        );
    }

    // 取款函数，用于将存储在合约中的cake币转移给调用者
    function withdraw(uint256 amount) public {
        // 检查调用者的余额足够
        require(
            balances[msg.sender] >= amount,
            "CakeContract: Insufficient balance"
        );
        // 更新调用者的余额
        balances[msg.sender] -= amount;
        // 将指定数量的代币发送到调用者地址
        cakeToken.transfer(msg.sender, amount);
        // 添加交易记录到列表中
        transactions.push(
            Transaction(address(this), msg.sender, amount, block.timestamp)
        );
    }

    // 转账函数，用于将cake币从调用者地址转移到指定的目标地址
    function transfer(address to, uint256 amount) public {
        // 检查调用者的余额足够
        require(
            balances[msg.sender] >= amount,
            "CakeContract: Insufficient balance"
        );
        // 更新调用者和目标地址的余额
        balances[msg.sender] -= amount;
        balances[to] += amount;
        // 将指定数量的代币发送到目标地址
        cakeToken.transfer(to, amount);
        // 添加交易记录到列表中
        transactions.push(Transaction(msg.sender, to, amount, block.timestamp));
    }

    // 查询交易记录函数，用于返回合约中所有的交易记录列表
    function getTransactions() public view returns (Transaction[] memory) {
        return transactions;
    }

   // 根据地址查询交易记录函数，用于返回指定地址在合约中的交易记录列表
    function getTransactionsByAddress(address addr) public view returns (Transaction[] memory) {
        // 声明一个临时数组，用于保存指定地址的交易记录
        Transaction[] memory result = new Transaction[](transactions.length);
        uint256 index = 0;
        // 遍历交易记录列表，查找所有与指定地址相关的交易记录
        for (uint256 i = 0; i < transactions.length; i++) {
            Transaction memory _tx = transactions[i];
            if (_tx.sender == addr || _tx.recipient == addr) {
                result[index] = _tx;
                index++;
            }
        }
        // 返回指定地址相关的交易记录列表
        return result;
    }
}