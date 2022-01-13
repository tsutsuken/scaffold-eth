import { BigInt, Address } from "@graphprotocol/graph-ts";
import {
  YourContract,
  SetPurpose,
  SetCount,
} from "../generated/YourContract/YourContract";
import { Purpose, Count, Sender } from "../generated/schema";

export function handleSetPurpose(event: SetPurpose): void {
  let senderString = event.params.sender.toHexString();

  let sender = Sender.load(senderString);

  if (sender === null) {
    sender = new Sender(senderString);
    sender.address = event.params.sender;
    sender.createdAt = event.block.timestamp;
    sender.purposeCount = BigInt.fromI32(1);
    sender.countCount = BigInt.fromI32(0);
  } else {
    sender.purposeCount = sender.purposeCount.plus(BigInt.fromI32(1));
  }

  let purpose = new Purpose(
    event.transaction.hash.toHex() + "-" + event.logIndex.toString()
  );

  purpose.purpose = event.params.purpose;
  purpose.sender = senderString;
  purpose.createdAt = event.block.timestamp;
  purpose.transactionHash = event.transaction.hash.toHex();

  purpose.save();
  sender.save();
}

export function handleSetCount(event: SetCount): void {
  let senderString = event.params.sender.toHexString();
  let sender = Sender.load(senderString);
  if (sender === null) {
    sender = new Sender(senderString);
    sender.address = event.params.sender;
    sender.createdAt = event.block.timestamp;
    sender.purposeCount = BigInt.fromI32(0);
    sender.countCount = BigInt.fromI32(1);
  } else {
    sender.countCount = sender.countCount.plus(BigInt.fromI32(1));
  }

  let count = new Count(
    event.transaction.hash.toHex() + "-" + event.logIndex.toString()
  );
  count.count = event.params.count;
  count.sender = senderString;
  count.createdAt = event.block.timestamp;
  count.transactionHash = event.transaction.hash.toHex();

  count.save();
  sender.save();
}
