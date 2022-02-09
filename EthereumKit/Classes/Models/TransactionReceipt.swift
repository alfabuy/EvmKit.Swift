import GRDB
import BigInt
import ObjectMapper

public class TransactionReceipt: Record {
    static let transactionForeignKey = ForeignKey([Columns.transactionHash])
    static let transaction = belongsTo(Transaction.self, using: transactionForeignKey)
    static let logs = hasMany(TransactionLog.self)

    public let transactionHash: Data
    public let transactionIndex: Int
    public let blockHash: Data
    public let blockNumber: Int
    public let from: Address
    public var to: Address?
    public let effectiveGasPrice: Int
    public let cumulativeGasUsed: Int
    public let gasUsed: Int
    public var contractAddress: Data?
    public let logsBloom: Data
    public let root: Data?
    public var status: Int?

    init(rpcReceipt: RpcTransactionReceipt) {
        transactionHash = rpcReceipt.transactionHash
        transactionIndex = rpcReceipt.transactionIndex
        blockHash = rpcReceipt.blockHash
        blockNumber = rpcReceipt.blockNumber
        from = rpcReceipt.from
        to = rpcReceipt.to
        effectiveGasPrice = rpcReceipt.effectiveGasPrice
        cumulativeGasUsed = rpcReceipt.cumulativeGasUsed
        gasUsed = rpcReceipt.gasUsed
        contractAddress = rpcReceipt.contractAddress
        logsBloom = rpcReceipt.logsBloom
        root = rpcReceipt.root
        status = rpcReceipt.status

        super.init()
    }

    public override class var databaseTableName: String {
        "transaction_receipts"
    }

    enum Columns: String, ColumnExpression, CaseIterable {
        case transactionHash
        case transactionIndex
        case blockHash
        case blockNumber
        case from
        case to
        case effectiveGasPrice
        case cumulativeGasUsed
        case gasUsed
        case contractAddress
        case logsBloom
        case root
        case status
    }

    required init(row: Row) {
        transactionHash = row[Columns.transactionHash]
        transactionIndex = row[Columns.transactionIndex]
        blockHash = row[Columns.blockHash]
        blockNumber = row[Columns.blockNumber]
        from = Address(raw: row[Columns.from])
        to = row[Columns.to].map { Address(raw: $0) }
        effectiveGasPrice = row[Columns.effectiveGasPrice]
        cumulativeGasUsed = row[Columns.cumulativeGasUsed]
        gasUsed = row[Columns.gasUsed]
        contractAddress = row[Columns.contractAddress]
        logsBloom = row[Columns.logsBloom]
        root = row[Columns.root]
        status = row[Columns.status]

        super.init(row: row)
    }

    public override func encode(to container: inout PersistenceContainer) {
        container[Columns.transactionHash] = transactionHash
        container[Columns.transactionIndex] = transactionIndex
        container[Columns.blockHash] = blockHash
        container[Columns.blockNumber] = blockNumber
        container[Columns.from] = from.raw
        container[Columns.to] = to?.raw
        container[Columns.effectiveGasPrice] = effectiveGasPrice
        container[Columns.cumulativeGasUsed] = cumulativeGasUsed
        container[Columns.gasUsed] = gasUsed
        container[Columns.contractAddress] = contractAddress
        container[Columns.logsBloom] = logsBloom
        container[Columns.root] = root
        container[Columns.status] = status
    }

}
