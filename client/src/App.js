import React, { Component } from "react";
import MarketPlaceContract from "./contracts/MarketPlace.json";
import WWTokenContract from "./contracts/WWToken.json";
import WWNFTTokenContract from "./contracts/WWNFTToken.json";
import getWeb3 from "./getWeb3";

import "./App.css";

class App extends Component {
  state = { storageValue: 0, web3: null, accounts: null, contract: null };

  componentDidMount = async () => {
    try {
      // Get network provider and web3 instance.
      this.web3 = await getWeb3();

      // Use web3 to get the user's accounts.
      this.accounts = await this.web3.eth.getAccounts();
      console.log(this.accounts)

      // Get the contract instance.
      this.networkId = await this.web3.eth.net.getId();
      this.MarketPlaceDeployedNetwork = MarketPlaceContract.networks[this.networkId];

      console.log(this.networkId);

      this.MarketPlaceInstance = new this.web3.eth.Contract(
        MarketPlaceContract.abi,
        this.MarketPlaceDeployedNetwork && this.MarketPlaceDeployedNetwork.address,
      );

      // Set web3, accounts, and contract to the state, and then proceed with an
      // example of interacting with the contract's methods.
      // this.setState({ web3, accounts, contract: instance }, this.runExample);
    } catch (error) {
      // Catch any errors for any of the above operations.
      alert(
        `Failed to load web3, accounts, or contract. Check console for details.`,
      );
      console.error(error);
    }
  };

  handleInputChange = (event) => {
    const target = event.target;
    const name = target.name;
    const value = target.value;
    this.setState({
      [name] : value
    });
  }

  handleMintSubmit = async() => {
    const {tokenAddress, amount} = this.state;
    this.accounts = await this.web3.eth.getAccounts();
    await this.MarketPlaceInstance.methods.mintToken().send({from: this.accounts[0]});

  }

  render() {
    if (!this.state.web3) {
      return <div>Loading Web3, accounts, and contract...</div>;
    }
    return (
      <div className="App">
        <h1>Mint NFT, buy and sell them!</h1>
        <button type="button" onClick={this.handleMintSubmit}> Mint NFT tokens </button>


        Enter Token's address:< input type="text" name="tokenAddress" onChange={this.handleInputChange} />
        Enter amount (18 decimal precesion by default): <input type="text" name="amount" onChange={this.handleInputChange} />
        <button type="button" onClick={this.handleSubmit}> Transfer tokens </button>
        <p><button type="button" onClick={this.handleWithdraw}> withdraw ether </button></p>
      </div>
    );
  }
}

export default App;
