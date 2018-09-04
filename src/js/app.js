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
      web3 = new Web3(web3.currentProvider);
    } else {
      // Specify default instance if no web3 instance provided
      App.web3Provider = new Web3.providers.HttpProvider('http://localhost:7545');
      web3 = new Web3(App.web3Provider);
    }
    return App.initContract();
  },

  initContract: function() {
    $.getJSON("ConcertTix.json", function(data) {
      var ConcertTixArtifact = data;
    // Instantiate a new truffle contract from the artifact
      App.contracts.ConcertTix = TruffleContract(ConcertTixArtifact);
    // Connect provider to interact with contract
      App.contracts.ConcertTix.setProvider(App.web3Provider);

      return App.transferFunds();
  });
},

transferFunds: function () {
    var x = document.getElementById("buyTicketsBtn");
    var ConcertTixInstance;
    App.contracts.ConcertTix.deployed().then(function(instance) {
      ConcerttixInstance = instance;

      x.addEventListener("click", function() {
        if(msg.value != ticketPrice) {
          alert("Error. Please send the exact amount of ether.");
        } elseif (ticketCount == 0) {
          alert("Tickets are sold out");
        } else {
          return ConcertTixInstance.transferFunds( {from: msg.sender, value: msg.value});
        }
      }

/*
      // do something with the events
      return ConcertTixInstance.buyTickets.call() {
        x.addEventListener("click", function() {
          if

        }
      }
      x.addEventListener("click", function() {
        // need to incorporate the buyTickets function in the contracts
        // check the users account and throw an alert
        // check the ticket count and throw an alert
        if all goes through, then
        msg.sender.transfer(toAddress, value, { from: addr, value: price})
        })
      }
    }



/*
buyBtn: function() {
  var x = document.getElementById("myBtn");
  App.contracts.Concerttix.deployed().then(function(instance) {
    var btnEventInstance = instance.buyTickets(function() {
      // add a promise to make the event listeners sequential
      x.addEventListener("click", buyTix);
      x.addEventListener("click", ticketCount);

      function buyTix() {
        return btnEventInstance {

        }
      }

      function ticketCount() {
        return btnEventInstance

      }

      }

      alert("Tickets are Sold Out")
      }
    }
  }
}
*/
/*
  buyTix: function() {
    var buyBtnInstance
  }


  ticketCount: function(adopters, account) {
    var ticketCountInstance;

    App.contracts.Concerttix.deployed().then(function(instance) {
      ticketCountInstance = instance;

      return ticketCountInstance =
    }
  },
};
*/

$(function() {
  $(window).load(function() {
    App.init();
  });
});
