import React, { useState } from "react";
import Davatar from "@davatar/react";
import { Button, Card, List } from "antd";
import { Address, AddressInput } from "../components";

const influencerAddressList = [
  "0x983110309620D911731Ac0932219af06091b6744",
  "0xE545c0D41c622bCCCc8f103c0607D042A2242350",
  "0x5A384227B65FA093DEC03Ec34e111Db80A040615",
  "0xa4c8d9e4ec5f2831701a81389465498b83f9457d",
  "0x961d2C942aECE305A9911652E1fb303A1e5D4902",
  "0xcEf871B113d2bB5d3FA5DC96d2D288dd38082AAE",
  "0x9297A132AF2A1481441AB8dc1Ce6e243d879eaFD",
  "0x5b0f8955658cB26f29695A00b36E1fE0259D4e0A",
];

export default function MyCollection({ provider, collectibles, blockExplorer }) {
  const [transferToAddresses, setTransferToAddresses] = useState({});

  return (
    <div>
      {influencerAddressList.map(influencerAddress => {
        return <Davatar size={120} provider={provider} address={influencerAddress} style={{ borderRadius: 0 }} />;
      })}
      <List
        bordered
        dataSource={collectibles}
        renderItem={item => {
          const id = item.id.toNumber();
          return (
            <List.Item key={id + "_" + item.uri + "_" + item.owner}>
              <Card
                title={
                  <div>
                    <span style={{ fontSize: 16, marginRight: 8 }}>#{id}</span> {item.name}
                  </div>
                }
              >
                <div>
                  <img src={item.image} style={{ maxWidth: 150 }} />
                </div>
                <div>{item.description}</div>
              </Card>

              <div>
                owner:{" "}
                <Address address={item.owner} ensProvider={provider} blockExplorer={blockExplorer} fontSize={16} />
                <Davatar size={100} provider={provider} address={item.owner} style={{ borderRadius: 0 }} />
                <AddressInput
                  ensProvider={provider}
                  placeholder="transfer to address"
                  value={transferToAddresses[id]}
                  onChange={newValue => {
                    const update = {};
                    update[id] = newValue;
                    setTransferToAddresses({ ...transferToAddresses, ...update });
                  }}
                />
                <Button
                  onClick={() => {
                    console.log("writeContracts", writeContracts);
                    tx(writeContracts.YourCollectible.transferFrom(address, transferToAddresses[id], id));
                  }}
                >
                  Transfer
                </Button>
              </div>
            </List.Item>
          );
        }}
      />
    </div>
  );
}
