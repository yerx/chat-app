App = {
  web3Provider: null,
  contracts: {},

  init: function() {
    return App.initWeb3();
  },

  initWeb3: function() {
    if (typeof web3 !== 'undefined') {
      // If a web3 instance is already provided by Meta Mask.
      App.web3Provider = web3.currentProvider;
    } else {
      // Specify default instance if no web3 instance provided
      App.web3Provider = new Web3.providers.HttpProvider('http://localhost:7545');
    }
    web3 = new Web3(App.web3Provider);

    return App.initContract();
  },

  initContract: function() {
    $.getJSON("ConcertTix.json", function(data) {
      ConcertTixArtifact = data;
    // Instantiate a new truffle contract from the artifact
      App.contracts.ConcertTix = TruffleContract(ConcertTixArtifact);
    // Connect provider to interact with contract
      App.contracts.ConcertTix.setProvider(App.web3Provider);

      return App.render();
    });
  },

// var contractAddress = '';
// var ApprovalContract = new web3.eth.Contract(abi, contractAddress);

  render: async function() {
    var contractAddress = '0x651fa3dec513ed3edbbe7776bf6a99cc8cc24a5d';
    var contract = await App.contracts.ConcertTix.deployed();
      /*App.contracts.ConcertTix.deployed().then(function(instance) {
      concertTixInstance = instance;*/
      $('#contract-form').submit(function() {
        event.preventDefault();
        var fromAddress = $('#fromAddress').val();
        var toAddress = $('#toAddress').val();
        var amount = $('#amount').val();
        if (web3.utils.isAddress(fromAddress) !=true) {
          alert('You did not enter the correct ethereum address for the sender address');
          return;
        }
        if (web3.utils.isAddress(toAddress) !=true) {
          alert('You did not enter a correct ethereum address for the receipient address');
          return;
        }
        if (amount != 2) {
          alert('You must send the exact amount of 2 ETH.');
          return;
        } else {
        // Approval Contract .methods -- need a 'then instance here'
          contract.methods.deposit(toAddress).send({from: fromAddress, value: web3.utils.toWei(amount, 'ether')},
            function(error, result) {
              if (error) {
                console.log('error: ' + error);
              } else {
                  $('#deposit-result').html('Succes TX: <b>' + result + '</b>');
                }
              })
          }
      });

      $('#get-balance-form').submit(function() {
        event.preventDefault();

        web3.eth.getBalance(contractAddress,
          function(error, result) {
            if (error) {
              console.log('error: ' + error);
            }
              else {
              console.log('balance: ' + result);
              $('#the-balance').html('<b>Current Balance:</b> ' + web3.utils.fromWei(result));
            }
          });
      });

        $('#approve-form').submit(function() {
          event.preventDefault();

          contract.methods.approve().call({from: '0x69ee9EC9045d3B650c1F52d40EAB79afB7458b0f' },
            function(error, result) {
              if (error) {
                console.log('error: ' + error);
              }
              else {
                console.log('result: ' + JSON.stringify(result));
                $('#approval-display').html('Transaction Approved. TX: <b>' + result + '</b>');
              }
            });
        });

        $('#approver-form').submit(function() {
          event.preventDefault();
          contract.methods.viewApprover().call(
            function(error, result) {
              if (error) {
                console.log('error: ' + error);
              }
              else {
                console.log('result: ' + JSON.stringify(result));
                $('#approver-display').html('Approver Address: <b>' + result + '</b>');
              }
            });
        });
      },
    };
