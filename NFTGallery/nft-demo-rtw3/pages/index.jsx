import { useState } from 'react'
import {NFTCard} from "./components/nftCard"

const Home = () => {
  const [wallet, setWalletAddress] = useState("");
  const [collection, setCollectionAddress] = useState("");
  const [NFTs, setNFTs] = useState([]);
  const [fetchForCollection, setFetchForCollection] = useState(false);

  const fetchNFTs = async() => {
    let nfts;

    const api_key = "MB_IXfne-cHm91RKlIhMW7uobXkAUwfr";
    const baseURL = `https://eth-mainnet.alchemyapi.io/v2/${api_key}/getNFTs/`;

    var requestOptions = {
      method: 'GET'
    };

    if(!collection.length) {  
      console.log("fetching NFTs owned by address");
      const fetchURL = `${baseURL}?owner=${wallet}`;
      nfts = await fetch(fetchURL, requestOptions).then(data => data.json());
    }
    else {
      console.log("Fetching NFTs for collection owned by address");
      const fetchURL = `${baseURL}?owner=${wallet}&contractAddresses%5B%5D=${collection}`;
      nfts = await fetch(fetchURL, requestOptions).then(data => data.json());
    }

    if (nfts)
    {
      console.log("NFTs: ",nfts);
      setNFTs(nfts.ownedNfts);
    }
  }

  const fetchNFTsForCollection = async () => {
    var requestOptions = {
      method: 'GET'
    };

    if( collection.length) {
      const api_key = "MB_IXfne-cHm91RKlIhMW7uobXkAUwfr";
      const baseURL = `https://eth-mainnet.alchemyapi.io/v2/${api_key}/getNFTsForCollection/`;

      console.log("Fetching NFTs for collection");

      const fetchURL = `${baseURL}?contractAddress=${collection}&withMetadata=${"true"}`;
      const {nfts, nextToken } = await fetch(fetchURL, requestOptions).then(data => data.json());

      if (nfts)
      {
        setNFTs(nfts);
      }
   }
  }

  return (
    <div className="flex flex-col items-center justify-center py-8 gap-y-3">
      <div className="flex flex-col w-full items-center justify-center gap-y-2">
        <input disabled={fetchForCollection}  className="w-2/5 bg-slate-200 py-2 px-2 rounded-lg text-gray-800 focus:outline-blue-300 disabled:bg-slate-50 disabled:text-gray-50" onChange={(e)=>{setWalletAddress(e.target.value)}} value={wallet} type={"text"} placeholder="Add your wallet address"></input>
        <input className="w-2/5 bg-slate-100 py-2 px-2 rounded-lg text-gray-800 focus:outline-blue-300 disabled:bg-slate-50 disabled:text-gray-50" onChange={(e)=>{setCollectionAddress(e.target.value)}} value={collection} type={"text"} placeholder="Add the collection address"></input>
        <label className="text-gray-600 "><input onChange={(e)=>{setFetchForCollection(e.target.checked)}} type={"checkbox"} className="mr-2"></input> Fetch for collection</label>
         <button className={"disabled:bg-slate-500 text-white bg-blue-400 px-4 py-2 mt-3 rounded-sm w-1/5"} onClick={
          () => {
             if(fetchForCollection) {
              fetchNFTsForCollection();
            }
            else {
              fetchNFTs();
            }
          }
        }>Let's GO!</button>
      </div>
      <div className='flex flex-wrap gap-y-12 mt-4 w-5/6 gap-x-2 justify-center'>
        {
          NFTs.length && NFTs.map(nft => {
            return (
              <NFTCard nft={nft}></NFTCard>
            )
          })
        }
      </div>
    </div>
  )
}

export default Home
