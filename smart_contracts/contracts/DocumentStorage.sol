// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DocumentStorage {
    struct Document {
        string name;
        string client1;
        string client2;
        string description;
        address owner;
        string status;
        uint256[] versions;
        mapping(address => bool) acl; // Access Control List
    }

    mapping(uint256 => Document) public documents;
    uint256 public documentCount;

    event DocumentUploaded(uint256 indexed documentId, string name, address indexed owner);
    event DocumentUpdated(uint256 indexed documentId, string status, address indexed owner);

    constructor() {
        documentCount = 0;
    }

    modifier onlyDocumentOwner(uint256 _documentId) {
        require(msg.sender == documents[_documentId].owner, "You are not the document owner.");
        _;
    }

    function uploadDocument(string memory _name, string memory _client1, string memory _client2, string memory _description, string memory _status) public {
        documentCount++;
        Document storage newDocument = documents[documentCount];
        newDocument.name = _name;
        newDocument.client1 = _client1;
        newDocument.client2 = _client2;
        newDocument.description = _description;
        newDocument.owner = msg.sender;
        newDocument.status = _status;
        emit DocumentUploaded(documentCount, _name, msg.sender);
    }

    function updateDocument(uint256 _documentId, string memory _description, string memory _status) public onlyDocumentOwner(_documentId) {
        documents[_documentId].description = _description;
        documents[_documentId].versions.push(block.timestamp);
        documents[_documentId].status = _status;
        emit DocumentUpdated(_documentId, _status, msg.sender);
    }

    function retrieveDocument(uint256 _documentId) public view returns (string memory, string memory, address) {
        Document storage doc = documents[_documentId];
        return (doc.name, doc.description, doc.owner);
    }
}